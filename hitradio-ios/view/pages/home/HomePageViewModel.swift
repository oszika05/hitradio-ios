//
//  HomePageViewModel.swift
//  hitradio-ios
//
//  Created by Zsolt Oszlányi on 2021. 10. 22..
//

import Foundation
import Combine

class HomePageViewModel: ObservableObject {
    @Published private(set) var news: [News] = []
    @Published private(set) var episodes: [Episode] = []
    @Published private(set) var guests: [Person] = []
    
    private var peopleSubscriptions = Set<AnyCancellable>()
    private var episodeSubscriptions = Set<AnyCancellable>()
    private var newsSubscriptions = Set<AnyCancellable>()
    
    init() {
        let programRepository = ProgramRepository()
        let newsRepository = NewsRepository()
        
        programRepository
            .getPeople(from: 0, pageSize: 5, personType: PersonType.Guest)
            .sink { completion in
                switch completion {
                case .finished:
                    print("finished")
                case .failure(let error):
                    print("error: \(error)")
                }
            } receiveValue: { guests in
                self.guests = guests
            }
            .store(in: &peopleSubscriptions)
        
        programRepository
            .getEpisodes(from: 0, pageSize: 5)
            .sink { completion in
                switch completion {
                case .finished:
                    print("finished")
                case .failure(let error):
                    print("error: \(error)")
                }
            } receiveValue: { episodes in
                self.episodes = episodes
            }
            .store(in: &episodeSubscriptions)
        
        newsRepository
            .getNews(from: 0, pageSize: 5)
            .sink { completion in
                switch completion {
                case .finished:
                    print("finished")
                case .failure(let error):
                    print("error: \(error)")
                }
            } receiveValue: { news in
                self.news = news
            }
            .store(in: &newsSubscriptions)

    }
}
