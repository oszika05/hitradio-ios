//
//  EpisodePageViewModel.swift
//  hitradio-ios
//
//  Created by Zsolt Oszlányi on 2021. 10. 22..
//

import Foundation
import Combine

class EpisodesPageViewModel: ObservableObject {
    
    private let repo = ProgramRepository()
    
    @Published private(set) var episodes: [Episode] = []
    
    @Published var search: String
    @Published private(set) var page: Int = 1
    @Published private(set) var areThereMore: Bool = true
    
    @Published private(set) var isLoading: Bool = false
    
    
    private var programId: String?
    private var tags: [String]
    private var people: [String]
    
    private var subscriptions = Set<AnyCancellable>()

    
    init(programId: String? = nil, tags: [String] = [], people: [String] = [], initialSearch: String = "") {
        self.programId = programId
        self.tags = tags
        self.people = people
        self.search = initialSearch
        
        self.$search
            .debounce(for: .seconds(0.3), scheduler: RunLoop.main)
            .map { (search) -> String in
                self.page = 1
                self.episodes = []
                self.areThereMore = true
                
                return search
            }
            .combineLatest($page)
            .map { (search, page) -> AnyPublisher<[Episode], Error> in
                let from = (page - 1) * EpisodesPageViewModel.pageSize

                self.isLoading = true
                
                return self.repo.getEpisodes(
                    from: from,
                    pageSize: EpisodesPageViewModel.pageSize,
                    programId: self.programId,
                    search: search,
                    tags: self.tags,
                    people: self.people
                )
            }
            .switchToLatest()
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("finished1")
                        self.isLoading = false
                        self.areThereMore = false
                    
                    case .failure(let error):
                        print("error: \(error)")
                        self.isLoading = false
                        self.episodes = []
                        self.areThereMore = false
                    }
                },
                receiveValue: { (episodes) in

                    self.isLoading = false
                    self.areThereMore = episodes.count == EpisodesPageViewModel.pageSize


                    self.episodes.append(contentsOf: episodes)

                }
            )
            .store(in: &subscriptions)
    }
    
    func fetchNext() {
        if !self.areThereMore {
            return
        }

        self.page += 1
    }
    
    private static let pageSize = 10
}
