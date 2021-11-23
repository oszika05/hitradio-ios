//
//  HomePage.swift
//  hitradio-ios
//
//  Created by Zsolt Oszlányi on 2021. 10. 21..
//

import SwiftUI

struct HomePage: View {
    
    @ObservedObject private var viewModel = HomePageViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                ZStack {
                    Card(
                        title: "This is a test",
                        picture: "https://images.immediate.co.uk/production/volatile/sites/30/2017/01/Bananas-218094b-scaled.jpg?quality=90&resize=960%2C872",
                        playbackState: .Stopped,
                        onClick: {
                            print("onClick")
                        },
                        onPlayPauseClick: {
                            print("onPlayPauseClick")
                        }
                    )
                }.padding(16.0)
                
                NavigationLink(destination: SettingsPage()) {
                    Text("settings")
                }
                
//                Spacer(minLength: 20.0)
                
                NavigationLink(destination: NewsPage()) {
                    Text("all news")
                }
                
//                Spacer(minLength: 5.0)
                
                ForEach(self.viewModel.news, id: \.id) { newsItem in
                    NavigationLink(destination: NewsItemPage(news: newsItem)) {
                        Text("\(newsItem.title)")
                    }
                }
                
//                Spacer(minLength: 20.0)
                
                NavigationLink(destination: EpisodesPage()) {
                    Text("all episodes")
                }
                
//                Spacer(minLength: 5.0)
                
                ForEach(self.viewModel.episodes, id: \.id) { episode in
                    NavigationLink(destination: EpisodePage(episode: episode)) {
                        Text("\(episode.title)")
                    }
                }
                
//                Spacer(minLength: 20.0)
                
                NavigationLink(destination: PeoplePage()) {
                    Text("all person")
                }
                
//                Spacer(minLength: 5.0)
                
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(self.viewModel.guests, id: \.id) { guest in
                            NavigationLink(destination: PersonPage(person: guest)) {
                                Text("\(guest.name)")
                            }
                        }
                    }
                }
            }
        }
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}
