//
//  EpisodePage.swift
//  hitradio-ios
//
//  Created by Zsolt Oszlányi on 2021. 10. 22..
//

import SwiftUI

struct EpisodePage: View {
    
    @ObservedObject private var viewModel: EpisodePageViewModel
    @EnvironmentObject private var audioController: AudioController
    
    init(episode: Episode) {
        viewModel = EpisodePageViewModel(episode: episode)
    }
    
    var body: some View {
        VStack {
            
            if viewModel.isLoading {
                ProgressView()
            } else {
                Text("\(viewModel.episode.title)")
                
                let isCurrentSource = audioController.getSource() != nil && audioController.getSource()?.id == viewModel.episode.asSource().id
                let isPlaying = isCurrentSource && audioController.isPlaying
                
                Button(action: {
                    if !isCurrentSource {
                        audioController.setSource(source: viewModel.episode.asSource())
                    } else {
                        audioController.playPause()
                    }
                }) {
                    Text(isPlaying ? "stop" : "play")
                }
                
                Text("\(viewModel.episode.description ?? "")")
                
                ScrollView(.horizontal) {
                    LazyHStack {
                        ForEach(self.viewModel.episode.tags, id: \.self) { tag in
                            Text("tag: \(tag)")
                        }
                    }
                }
                
                ScrollView(.horizontal) {
                    LazyHStack {
                        ForEach(self.viewModel.episode.guests, id: \.id) { guest in
                            NavigationLink(destination: PersonPage(person: guest)) {
                                Text("guest: \(guest.name)")
                            }
                            
                        }
                    }
                }
                
                ScrollView(.horizontal) {
                    LazyHStack {
                        ForEach(self.viewModel.episode.hosts, id: \.id) { host in
                            NavigationLink(destination: PersonPage(person: host)) {
                                Text("host: \(host.name)")
                            }
                        }
                    }
                }
                
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    ScrollView(.horizontal) {
                        LazyHStack {
                            ForEach(self.viewModel.related, id: \.id) { relatedEpisode in
                                NavigationLink(destination: EpisodePage(episode: relatedEpisode)) {
                                    Text("related: \(relatedEpisode.title)")
                                }
                            }
                        }
                    }
                }
                
                
                
            }
            
            Spacer()
        }
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

//struct EpisodePage_Previews: PreviewProvider {
//    static var previews: some View {
//        EpisodePage(episode: Episode(id: "", title: String, date: <#T##Date#>, description: <#T##String?#>, tags: <#T##[String]#>, program: <#T##Program#>, audioUrl: <#T##String#>, hosts: <#T##[Person]#>, guests: <#T##[Person]#>))
//    }
//}
