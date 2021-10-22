//
//  ProgramsPage.swift
//  hitradio-ios
//
//  Created by Zsolt Oszlányi on 2021. 10. 22..
//

import SwiftUI

struct ProgramsPage: View {
    @ObservedObject private var viewModel: ProgramsPageViewModel
    
    init(initialSearch: String = "") {
        viewModel = ProgramsPageViewModel(initialSearch: initialSearch)
    }
    
    var body: some View {
        VStack {
            TextField("Search...", text: $viewModel.search)
            
            List(viewModel.programs, id: \.id) { program in
                NavigationLink(destination: ProgramPage(program: program)) {
                    Text("\(program.name)")
                        .onAppear {
                            if self.viewModel.programs.last == program {
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

struct ProgramsPage_Previews: PreviewProvider {
    static var previews: some View {
        ProgramsPage()
    }
}
