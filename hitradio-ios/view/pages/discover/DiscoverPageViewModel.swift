//
//  DiscoverPAgeViewModel.swift
//  hitradio-ios
//
//  Created by Zsolt Oszlányi on 2021. 10. 21..
//

import Foundation
import Combine

class DiscoverPageViewModel: ObservableObject {
    @Published private(set) var page: Int = 1
    @Published var search = ""
    
    @Published private(set) var programs: [Program] = []
    @Published private(set) var people: [Person] = []
    @Published private(set) var episodes: [Episode] = []
    
    @Published private(set) var isLoading: Bool = false
    
    private var isThereMore = true
    
    private let programRepository = ProgramRepository()
    
    private var subscriptions = Set<AnyCancellable>()
    private var programSubscriptions = Set<AnyCancellable>()
    private var peopleSubscriptions = Set<AnyCancellable>()
    
    init() {
        let sharedSearch = $search
            .debounce(for: .seconds(0.3), scheduler: RunLoop.main)
            .share()
        
        sharedSearch
            .map { (search) -> AnyPublisher<[Program], Error> in
                //                self.programs = []
                print("getting programs")
                return self.programRepository.getPrograms(from: 0, pageSize:  DiscoverPageViewModel.noPaginationPageSize, search: search)
            }
            .switchToLatest()
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("finished")
                    case .failure(let error):
                        print("error: \(error)")
                        self.programs = []
                    }
                },
                receiveValue: { (programs) in
                    print("got programs")
                    self.programs = programs
                }
            )
            .store(in: &programSubscriptions)
        
        sharedSearch
            .map { (search) -> AnyPublisher<[Person], Error> in
                return self.programRepository.getPeople(from: 0, pageSize:  DiscoverPageViewModel.noPaginationPageSize, search: search)
            }
            .switchToLatest()
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("people finished")
                    case .failure(let error):
                        print("people error: \(error)")
                        self.people = []
                    }
                },
                receiveValue: { (people) in
                    self.people = people
                }
            )
            .store(in: &peopleSubscriptions)
        
        sharedSearch
            .map { (search) -> String in
                self.page = 1
                self.episodes = []
                
                return search
            }
            .combineLatest($page)
            .map { (search, page) -> AnyPublisher<[Episode], Error> in
                let from = (page - 1) * DiscoverPageViewModel.pageSize
                
                self.isLoading = true
                
                return self.programRepository.getEpisodes(
                    from: from,
                    pageSize: DiscoverPageViewModel.pageSize,
                    programId: nil,
                    search: search
                )
            }
            .switchToLatest()
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("episode finished")
                    case .failure(let error):
                        print("episode error: \(error)")
                        self.episodes = []
                    }
                },
                receiveValue: { (episodes) in
                    self.isLoading = false
                    self.isThereMore = episodes.count == DiscoverPageViewModel.pageSize
                    
                    
                    self.episodes.append(contentsOf: episodes)
                }
            )
            .store(in: &subscriptions)
    }
    
    func fetchNext() {
        if !self.isThereMore {
            return
        }
        
        self.page += 1
    }
    
    private static let pageSize = 5
    private static let noPaginationPageSize = 15
}
