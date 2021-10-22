//
//  PersonPage.swift
//  hitradio-ios
//
//  Created by Zsolt Oszlányi on 2021. 10. 22..
//

import SwiftUI

struct PersonPage: View {
    
    @ObservedObject private var viewModel: PersonPageViewModel
    
    init(person: Person) {
        self.viewModel = PersonPageViewModel(person: person)
    }
    
    var body: some View {
        VStack {
            Text("\(viewModel.person.name)")
            
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

//struct PersonPage_Previews: PreviewProvider {
//    static var previews: some View {
//        PersonPage()
//    }
//}
