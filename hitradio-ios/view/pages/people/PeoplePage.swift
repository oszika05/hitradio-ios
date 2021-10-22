//
//  PeoplePage.swift
//  hitradio-ios
//
//  Created by Zsolt Oszlányi on 2021. 10. 22..
//

import SwiftUI

struct PeoplePage: View {
    
    @ObservedObject private var hostViewModel: PeoplePageViewModel
    @ObservedObject private var guestViewModel: PeoplePageViewModel
    
    @State var page = 0
    var types = ["Guests", "Hosts"]
    
    init(search: String? = nil) {
        self.hostViewModel = PeoplePageViewModel(personType: PersonType.Host, search: search)
        self.guestViewModel = PeoplePageViewModel(personType: PersonType.Guest, search: search)
    }
    
    var body: some View {
        VStack {
            Picker("Person type", selection: $page) {
                ForEach(0 ..< types.count) { index in
                    Text(self.types[index])
                        .tag(index)
                }
                
            }.pickerStyle(SegmentedPickerStyle())
            
            TabView(selection: $page) {
                
                VStack {
                    List(hostViewModel.people, id: \.id) { person in
                        NavigationLink(destination: PersonPage(person: person)) {
                            Text("\(person.name)").onAppear {
                                if self.hostViewModel.people.last == person {
                                    self.hostViewModel.fetchNext()
                                }
                            }
                        }
                    }
                    
                    if hostViewModel.isLoading {
                        ProgressView()
                    }
                }.tag(0)
                
                VStack {
                    List(guestViewModel.people, id: \.id) { person in
                        NavigationLink(destination: PersonPage(person: person)) {
                            Text("\(person.name)").onAppear {
                                if self.guestViewModel.people.last == person {
                                    self.guestViewModel.fetchNext()
                                }
                            }
                        }
                    }
                    
                    if guestViewModel.isLoading {
                        ProgressView()
                    }
                }.tag(1)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        
    }
}

struct PeoplePage_Previews: PreviewProvider {
    static var previews: some View {
        PeoplePage()
    }
}
