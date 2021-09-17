import Foundation

import StreamingKit

class AudioPlayer {
    
    private let player = STKAudioPlayer()
    
    private(set) var source: String? = nil
    
    private(set) var isPlaying: Bool = false
    private(set) var isBuffering: Bool = false
    
    private var delegate: Delegate? = nil
    
    private var observer: AudioPlayingStateObserver? = nil
    
    init() {
        let delegate = Delegate(onChange: { state in
            print("state changed: \(state) \(self.checkIsPlaying(state: state))")
            self.isPlaying = self.checkIsPlaying(state: state)
            self.observer?.onIsPlayingChange(isPlaying: self.isPlaying)
        })
        player.delegate = delegate
        self.delegate = delegate
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
        
        if self.isPlaying || self.isBuffering {
            return
        }
        
        self.player.play(self.source!)
    }
    
    func pause() {
        if self.source == nil {
            return
        }
        
        // TODO what about buffering
        if !self.isPlaying {
            return
        }
        
        self.player.pause()
    }
    
    func stop() {
        if self.source == nil {
            return
        }
        
        // TODO what about buffering
        if !self.isPlaying {
            return
        }
        
        self.player.stop()
    }
    
    
    func checkIsPlaying(state: STKAudioPlayerState) -> Bool {
        return AudioPlayer.playingStates.contains(state)
    }
    
    private static let playingStates: [STKAudioPlayerState] = [
        STKAudioPlayerState.running,
        STKAudioPlayerState.playing,
        STKAudioPlayerState.buffering
    ]
    
    class Delegate : NSObject, STKAudioPlayerDelegate {
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
