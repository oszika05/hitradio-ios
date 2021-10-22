//
//  DiscoverPage.swift
//  hitradio-ios
//
//  Created by Zsolt Oszlányi on 2021. 10. 21..
//

import SwiftUI

struct DiscoverPage: View {

    @ObservedObject private var viewModel: DiscoverPageViewModel = DiscoverPageViewModel()

    var body: some View {
        VStack {
            TextField("Search...", text: $viewModel.search)

            NavigationLink(destination: ProgramsPage(initialSearch: viewModel.search)) {
                Text("show all programs")
            }
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(viewModel.programs, id: \.id) { program in
                        NavigationLink(destination: ProgramPage(program: program)) {
                            Text("Program \(program.name)")
                        }
                    }
                }
            }

            NavigationLink(destination: PeoplePage(search: viewModel.search)) {
                Text("show all people")
            }
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(viewModel.people, id: \.id) { person in
                        NavigationLink(destination: PersonPage(person: person)) {
                            Text("person \(person.name)")
                        }
                    }
                }
            }

            List {
                ForEach(
                    viewModel.episodes,
                    id: \.id
                ) { item in
                    NavigationLink(destination: EpisodePage(episode: item)) {
                        Text(item.title).onAppear {
                            if self.viewModel.episodes.last == item {
                                self.viewModel.fetchNext()
                            }
                        }
                    }
                }

                if viewModel.isLoading {
                    ProgressView()
                }
            }

            Spacer()
        }
    }
}

struct DiscoverPage_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverPage()
    }
}
