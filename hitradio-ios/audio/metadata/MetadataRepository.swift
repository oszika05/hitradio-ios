//
//  MetadataRepository.swift
//  HitRadioBudapest
//
//  Created by Zsolt Oszlányi on 2020. 12. 14..
//  Copyright © 2020. Oszlányi Zsolt. All rights reserved.
//

import Foundation
import Combine
import MediaPlayer

class MetadataRepository: ObservableObject {
//    var songConnection = SongConnection()
    
    @Published var songData: SongEvent? = nil
    
    private let mediaCenterInfo = MPNowPlayingInfoCenter.default()
    
    private var podcastItem: PodcastItem? = nil
    private var liveData: SongEvent? = nil
    
    private var anyCancellable: AnyCancellable? = nil
    
    init() {
//        anyCancellable = songConnection.$songData.sink { [weak self] (songData) in
//            self?.liveData = songData
//
//            if self?.podcastItem == nil {
//                self?.songData = songData
//            }
//
//            self?.updateMetadata()
//        }
    }
    
    func setCurrent(podcast: PodcastItem? = nil) {
        self.podcastItem = podcast
        
        if podcast == nil {
            songData = liveData
        } else {
            songData = SongEvent(id: -podcast!.id, song: Song(id: -podcast!.id, title: podcast!.name, artist: podcast!.programName, jazlerId: "", length: podcast!.length), time: DateInterval())
        }
        
        updateMetadata()
    }
    
    private func updateMetadata() {
        print("metadata update 0")
        
        if (songData == nil) {
            return
        }

        print("metadata update")

        var nowPlayingInfo = mediaCenterInfo.nowPlayingInfo ?? [String: Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = songData!.song.title
        nowPlayingInfo[MPMediaItemPropertyArtist] = songData!.song.artist
//        nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = "hitradio"
//        nowPlayingInfo[MPMediaItemPropertyArtwork] = "hitradio"
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = 0.0
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 1.0
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = Double.infinity
        mediaCenterInfo.nowPlayingInfo = nowPlayingInfo

        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            
        }
    }
}
