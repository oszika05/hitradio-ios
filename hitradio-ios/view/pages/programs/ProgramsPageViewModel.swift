//
//  ProgramsPageViewModel.swift
//  hitradio-ios
//
//  Created by Zsolt Oszlányi on 2021. 10. 22..
//

import Foundation
import Combine

class ProgramsPageViewModel: ObservableObject {
    private let repo = ProgramRepository()
    
    @Published private(set) var programs: [Program] = []
    
    @Published var search: String
    @Published private(set) var page: Int = 1
    @Published private(set) var areThereMore: Bool = true
    
    @Published private(set) var isLoading: Bool = false
    
    private var subscriptions = Set<AnyCancellable>()

    
    init(initialSearch: String = "") {
        self.search = initialSearch
        
        self.$search
            .debounce(for: .seconds(0.3), scheduler: RunLoop.main)
            .map { (search) -> String in
                self.page = 1
                self.programs = []
                self.areThereMore = true
                
                return search
            }
            .combineLatest($page)
            .map { (search, page) -> AnyPublisher<[Program], Error> in
                let from = (page - 1) * ProgramsPageViewModel.pageSize

                self.isLoading = true
                
                return self.repo.getPrograms(
                    from: from,
                    pageSize: ProgramsPageViewModel.pageSize,
                    search: search
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
                        self.programs = []
                        self.areThereMore = false
                    }
                },
                receiveValue: { (programs) in

                    self.isLoading = false
                    self.areThereMore = programs.count == ProgramsPageViewModel.pageSize


                    self.programs.append(contentsOf: programs)

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
