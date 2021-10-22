//
//  ProgramPage.swift
//  hitradio-ios
//
//  Created by Zsolt Oszlányi on 2021. 10. 22..
//

import SwiftUI

struct ProgramPage: View {
    
    @ObservedObject private var viewModel: ProgramPageViewModel
    
    init(program: Program) {
        self.viewModel = ProgramPageViewModel(program: program)
    }
    
    var body: some View {
        VStack {
            Text("\(viewModel.program.name)")
            
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

//struct ProgramPage_Previews: PreviewProvider {
//    static var previews: some View {
//        ProgramPage(p)
//    }
//}
