import Foundation

import StreamingKit
import MediaPlayer

class AudioPlayer {

    private let player = STKAudioPlayer()

    private(set) var source: String? = nil

    private(set) var playbackState: PlaybackState = PlaybackState.Stopped

    private var delegate: Delegate? = nil

    private var observer: AudioPlayingStateObserver? = nil

    init() {
        let delegate = Delegate(onChange: { state in
            self.playbackState = PlaybackState.from(playerState: state)
            self.observer?.onIsPlayingChange(state: self.playbackState)
        })
        player.delegate = delegate
        self.delegate = delegate

        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget { event in
//            let source = self.source
//
//            if source == nil {
//                return .commandFailed
//            }

            self.player.resume()
            return .success
        }
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget { event in
            self.player.pause()
            return .success
        }
    }

    func setObserver(observer: AudioPlayingStateObserver) {
        self.observer = observer
    }

    func removeObserver() {
        self.observer = nil
    }

    func changeSource(url: String) {
        if url == self.source {
            self.play()
            return
        }

        self.source = url

        self.player.play(url)

    }

    func play() {
        if self.source == nil {
            return
        }

        if self.playbackState == PlaybackState.Stopped || self.playbackState == PlaybackState.Buffering {
            return
        }

        if self.player.state == STKAudioPlayerState.paused {
            self.player.resume()
            return
        }

        self.player.play(self.source!)
    }

    func pause() {
        if self.source == nil {
            return
        }

        // TODO what about buffering
        if self.playbackState == PlaybackState.Stopped {
            return
        }

        self.player.pause()
    }

    func stop() {
        if self.source == nil {
            return
        }

        if self.playbackState == PlaybackState.Stopped {
            return
        }

        self.player.stop()
    }

    func seekTo(position: Double) {
        self.player.seek(toTime: position)
    }

    func getCurrentDuration() -> Double {
        return self.player.duration
    }

    func getCurrentProgress() -> Double {
        return self.player.progress
    }


    func checkIsPlaying(state: STKAudioPlayerState) -> Bool {
        return AudioPlayer.playingStates.contains(state)
    }

    private static let playingStates: [STKAudioPlayerState] = [
        STKAudioPlayerState.running,
        STKAudioPlayerState.playing,
        STKAudioPlayerState.buffering
    ]

    class Delegate: NSObject, STKAudioPlayerDelegate {
        private let onChange: (_ state: STKAudioPlayerState) -> ()

        init(onChange: @escaping (_ state: STKAudioPlayerState) -> ()) {
            self.onChange = onChange
        }

        func audioPlayer(_ audioPlayer: STKAudioPlayer, didStartPlayingQueueItemId queueItemId: NSObject) {
            print("didStartPlayingQueueItemId \(queueItemId)")
        }

        func audioPlayer(_ audioPlayer: STKAudioPlayer, didFinishBufferingSourceWithQueueItemId queueItemId: NSObject) {
            print("didFinishBufferingSourceWithQueueItemId \(queueItemId)")
        }

        func audioPlayer(_ audioPlayer: STKAudioPlayer, stateChanged state: STKAudioPlayerState, previousState: STKAudioPlayerState) {
            self.onChange(state)
        }

        func audioPlayer(_ audioPlayer: STKAudioPlayer, didFinishPlayingQueueItemId queueItemId: NSObject, with stopReason: STKAudioPlayerStopReason, andProgress progress: Double, andDuration duration: Double) {
            print("stopReason \(stopReason.rawValue) progress: \(progress) duration: \(duration) queueItemId: \(queueItemId)")
        }

        func audioPlayer(_ audioPlayer: STKAudioPlayer, unexpectedError errorCode: STKAudioPlayerErrorCode) {
            print("unexpectedError \(errorCode)")
        }

    }


}
