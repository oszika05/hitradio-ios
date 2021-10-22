//
//  PersonPageViewModel.swift
//  hitradio-ios
//
//  Created by Zsolt Oszlányi on 2021. 10. 22..
//

import Foundation
import Combine

class PersonPageViewModel: ObservableObject {
    @Published private(set) var person: Person
    
    private let repo = ProgramRepository()
    
    @Published private(set) var episodes: [Episode] = []
    
    @Published private(set) var page: Int = 1
    @Published private(set) var areThereMore: Bool = true
    
    @Published private(set) var isLoading: Bool = false
    
    private var subscriptions = Set<AnyCancellable>()

    
    init(person: Person) {
        self.person = person
        
        self.$page
            .map { (page) -> AnyPublisher<[Episode], Error> in
                let from = (page - 1) * PersonPageViewModel.pageSize

                self.isLoading = true
                
                return self.repo.getEpisodes(
                    from: from,
                    pageSize: PersonPageViewModel.pageSize,
                    people: [self.person.id]
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
                    self.areThereMore = episodes.count == PersonPageViewModel.pageSize


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
