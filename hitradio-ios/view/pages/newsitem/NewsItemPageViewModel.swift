//
//  NewsItemPageViewModel.swift
//  hitradio-ios
//
//  Created by Zsolt Oszlányi on 2021. 10. 22..
//

import Foundation
import Combine

class NewsItemPageViewModel: ObservableObject {
    @Published private(set) var news: News?
    @Published private(set) var isLoading: Bool
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(news: News) {
        self.news = news
        self.isLoading = false
    }
    
    init(id: String) {
        print("news init \(id)")
        self.news = nil
        self.isLoading = true
        NewsRepository()
            .getNewsItem(id: id)
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("news loading finished")
                case .failure(let error):
                    print("news item error: \(error)")
                }
                self.isLoading = false
            } receiveValue: { item in
                print("news arrived: \(item.title)")
                self.news = item
                self.isLoading = false
            }
            .store(in: &subscriptions)
        
    }
}
