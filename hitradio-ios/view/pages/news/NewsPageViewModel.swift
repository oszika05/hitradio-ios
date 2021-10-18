//
//  NewsPageViewModel.swift
//  hitradio-ios
//
//  Created by Zsolt Oszlányi on 2021. 10. 14..
//

import Foundation
import Combine

class NewsPageViewModel: ObservableObject {

    @Published private(set) var page: Int = 1
    @Published var search = ""


    @Published private(set) var news: [News] = []
    @Published private(set) var isLoading: Bool = false

    private var isThereMore = true

    private let newsRepository = NewsRepository()

    private var subscriptions = Set<AnyCancellable>()

    init() {
        $search
            .debounce(for: .seconds(0.3), scheduler: RunLoop.main)
            .map { (search) -> String in
                self.page = 1
                self.news = []
                
                return search
            }
            .combineLatest($page)
            .map { (search, page) -> AnyPublisher<[News], Error> in
                let from = (page - 1) * NewsPageViewModel.pageSize

                self.isLoading = true
                
                return self.newsRepository.getNews(
                    from: from,
                    pageSize: NewsPageViewModel.pageSize,
                    search: search
                )
            }
            .switchToLatest()
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { (news) in
                    print("news length: \(news). search: \(self.search), page: \(self.page)\n")

                    self.isLoading = false
                    self.isThereMore = news.count == NewsPageViewModel.pageSize


                    self.news.append(contentsOf: news)

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
}
