import Foundation
import StreamingKit

protocol AudioPlayingStateObserver {
    func onIsPlayingChange(state: PlaybackState)
}

enum PlaybackState {
    case Playing
    case Buffering
    case Stopped
    
    static func from(playerState: STKAudioPlayerState) -> PlaybackState {
        switch (playerState) {
        case STKAudioPlayerState.playing:
            return .Playing
        case STKAudioPlayerState.buffering:
            return .Buffering
        default:
            return .Stopped
        }
        
        return .Stopped
    }
}
