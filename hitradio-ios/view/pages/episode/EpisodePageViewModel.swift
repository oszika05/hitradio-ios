//
//  EpisodePageViewModel.swift
//  hitradio-ios
//
//  Created by Zsolt Oszlányi on 2021. 10. 22..
//

import Foundation
import Combine

class EpisodePageViewModel: ObservableObject {
    @Published private(set) var episode: Episode
    @Published private(set) var related: [Episode] = []
    @Published private(set) var isLoading: Bool = true
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(episode: Episode) {
        self.episode = episode
        
        ProgramRepository()
            .getRelatedEpisodes(episodeId: episode.id)
            .sink { completion in
                switch completion {
                case .finished:
                    print("finished11")
                    self.isLoading = false
                case .failure(let error):
                    print("error: \(error)")
                    self.related = []
                    self.isLoading = false
                }
            } receiveValue: { related in
                self.related = related
                self.isLoading = false
            }
            .store(in: &subscriptions)

    }
}
