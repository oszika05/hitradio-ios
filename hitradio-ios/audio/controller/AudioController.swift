import Foundation
import Reachability
import MediaPlayer
import Combine

class AudioController: ObservableObject, MetadataObserver, AudioPlayingStateObserver {
    // TODO:
    // get playing state, length and seek point from player
    // test

    @Published private(set) var isPlaying: Bool = false
    @Published private(set) var metadata: MetaData? = nil

    var anyCancellable: AnyCancellable? = nil

    var relativeSeekPosition: Double {
        set(newValue) {
            self.seekPositionManager.relativePosition = newValue
        }

        get {
            return self.seekPositionManager.relativePosition
        }
    }

    var seekPositionInSeconds: Double {
        return self.seekPositionManager.positionInSeconds
    }
    var durationInSeconds: Double {
        return self.seekPositionManager.durationInSeconds
    }

    private var player: AudioPlayer

    private let systemMetadataUpdater = SystemMetadataUpdater()
    private let netowrkObserver = NetworkObserver()
    @Published private var seekPositionManager: SeekPositionManager

    private var source: Source?


    init(player: AudioPlayer) {
        self.player = player

        self.seekPositionManager = SeekPositionManager(player: player)
        self.seekPositionManager.start()

        self.netowrkObserver.observe { quality in
            if self.source != nil {
                self.player.changeSource(url: self.source!.url.get(quality: quality))
            }
        }

        self.player.setObserver(observer: self)

        anyCancellable = self.seekPositionManager.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
        }
    }

    deinit {
        self.seekPositionManager.stop()
        self.netowrkObserver.removeObserver()
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
            let quality = self.netowrkObserver.currentQuality

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
            self.player.pause()
        } else {
            self.player.play()
        }
    }

    func seekTo(position: Double) {
        self.player.seekTo(position: position)
    }

    func onMetadataChanged(metadata: MetaData) {
        self.metadata = metadata

        self.systemMetadataUpdater.updateMetadata(
            metadata: metadata
        )
    }
}
