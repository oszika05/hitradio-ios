import Foundation

protocol AudioPlayingStateObserver {
    func onIsPlayingChange(isPlaying: Bool)
}
