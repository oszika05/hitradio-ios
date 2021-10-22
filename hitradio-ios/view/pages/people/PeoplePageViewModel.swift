//
//  PeoplePageViewModel.swift
//  hitradio-ios
//
//  Created by Zsolt Oszlányi on 2021. 10. 22..
//

import Foundation
import Combine

class PeoplePageViewModel: ObservableObject {
    
    private let repo = ProgramRepository()
    
    @Published private(set) var people: [Person] = []
    
    @Published private(set) var page: Int = 1
    @Published private(set) var areThereMore: Bool = true
    
    @Published private(set) var isLoading: Bool = false
    
    private var personType: PersonType?
    
    private var subscriptions = Set<AnyCancellable>()
    
    private var search: String?

    
    init(personType: PersonType? = nil, search: String? = nil) {
        self.personType = personType
        self.search = search
        
        if search == "" {
            self.search = nil
        }
        
        self.$page
            .map { (page) -> AnyPublisher<[Person], Error> in
                let from = (page - 1) * PeoplePageViewModel.pageSize

                self.isLoading = true
                
                return self.repo.getPeople(
                    from: from,
                    pageSize: PeoplePageViewModel.pageSize,
                    search: self.search,
                    personType: self.personType
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
                        self.people = []
                        self.areThereMore = false
                    }
                },
                receiveValue: { (people) in
                    self.isLoading = false
                    self.areThereMore = people.count == PeoplePageViewModel.pageSize

                    self.people.append(contentsOf: people)
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
