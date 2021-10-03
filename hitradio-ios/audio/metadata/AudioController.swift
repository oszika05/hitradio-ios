import Foundation
import Reachability
import MediaPlayer

class AudioController: ObservableObject, MetadataObserver, AudioPlayingStateObserver {
    // TODO:
    // get playing state, length and seek point from player
    // test

    @Published private(set) var isPlaying: Bool = false
    @Published private(set) var metadata: MetaData? = nil

    private var player: AudioPlayer
    private var reachability: Reachability? = nil
    
    private let systemMetadataUpdater = SystemMetadataUpdater()

    private var connection: Reachability.Connection? = nil

    private var source: Source?

    init(player: AudioPlayer) {
        self.player = player

        do {
            self.reachability = try Reachability()
        } catch {
            print("Unable to create notifier")
        }

        self.player.setObserver(observer: self)

        self.reachability?.whenReachable = { reachability in
            self.connection = reachability.connection

            if self.source != nil {
                let quality = self.connection == Reachability.Connection.wifi ? StreamQuality.High : StreamQuality.Low
                self.player.changeSource(url: self.source!.url.get(quality: quality))
            }

        }
        self.reachability?.whenUnreachable = { _ in
            self.connection = nil
        }

        do {
            try self.reachability?.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }

    deinit {
        self.reachability?.stopNotifier()
        self.player.removeObserver()
    }

    func onIsPlayingChange(isPlaying: Bool) {
        self.isPlaying = isPlaying
        
        self.systemMetadataUpdater.updateProgress(
            progress: self.player.getCurrentProgress(),
            duration: self.player.getCurrentDuration()
        )
    }

    func setSource(source: Source?) {
        self.source = source

        source?.subscribe(observer: self)

        if source != nil {
            let quality = self.connection == Reachability.Connection.wifi ? StreamQuality.High : StreamQuality.Low

            print("chnage source")
            self.player.changeSource(url: source!.url.get(quality: quality))
            print("source changed")

            print("play")
            self.player.play()
            print("after play")
        } else {
            self.player.stop()
        }

    }

    func playPause() {
        if self.player.isPlaying {
            self.player.stop()
        } else {
            self.player.play()
        }
    }

    func onMetadataChanged(metadata: MetaData) {
        self.metadata = metadata
        
        self.systemMetadataUpdater.updateMetadata(
            metadata: metadata
        )
    }
}
