//
//  EpisodePage.swift
//  hitradio-ios
//
//  Created by Zsolt Oszlányi on 2021. 10. 22..
//

import SwiftUI

struct EpisodesPage: View {
    
    @ObservedObject private var viewModel: EpisodesPageViewModel
    
    init(programId: String? = nil, initialSearch: String = "", tags: [String] = [], people: [String] = []) {
        viewModel = EpisodesPageViewModel(programId: programId, tags: tags, people: people, initialSearch: initialSearch)
    }
    
    var body: some View {
        VStack {
            TextField("Search...", text: $viewModel.search)
            
            List(viewModel.episodes, id: \.id) { episode in
                NavigationLink(destination: EpisodePage(episode: episode)) {
                    Text("\(episode.title)")
                        .onAppear {
                            if self.viewModel.episodes.last == episode {
                                self.viewModel.fetchNext()
                            }
                        }
                }
                
            }
            
            if viewModel.isLoading {
                ProgressView()
            }
            
            
            
            Spacer()
        }
    }
}

struct EpisodesPage_Previews: PreviewProvider {
    static var previews: some View {
        EpisodesPage()
    }
}
