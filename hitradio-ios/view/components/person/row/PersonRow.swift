//
//  PersonRow.swift
//  hitradio-ios
//
//  Created by Zsolt Oszlányi on 2021. 11. 23..
//

import SwiftUI

struct PersonRow: View {
    
    enum BackgroundVariant {
        case card
        case transparent
    }
    
    var people: [Person]
    var backgroundVariant: BackgroundVariant = .card
    var onPersonClick: (_ person: Person) -> Void = { _ in }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top) {
                ForEach(people, id: \.id) { person in
                    PersonCard(
                        person: person,
                        onClick: { onPersonClick(person) }
                    )
                        .padding(.horizontal, 16)
                        .padding(.vertical, 16)
                }
            }
            .padding(.horizontal, 20)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .background(backgroundVariant == .card ? Color.whiteColor : Color.transparentColor)
            .boxShadow(enabled: backgroundVariant == .card)
            .padding(.horizontal, 20)
            .padding(.top, 40)
            .padding(.bottom, 80)
            
        }
        .frame(width: .infinity)
    }
}

struct PersonRow_Previews: PreviewProvider {
    static var previews: some View {
        PersonRow(
            people: [
                Person(
                    id: "1",
                    name: "Test Elemer lkdsjflkdas jflkdsj lkdsa",
                    type: .Guest
                ),
                Person(
                    id: "2",
                    name: "Test Elemer",
                    type: .Guest
                ),
                Person(
                    id: "3",
                    name: "Elme Bajnok",
                    type: .Guest
                ),
                Person(
                    id: "4",
                    name: "Ember Ember",
                    type: .Guest
                ),
                Person(
                    id: "5",
                    name: "Alma Alma",
                    type: .Guest
                ),
                Person(
                    id: "6",
                    name: "Teszt Teszt",
                    type: .Guest
                )
            ]
        )
        
        PersonRow(
            people: [
                Person(
                    id: "1",
                    name: "Test Elemer lkdsjflkdas jflkdsj lkdsa",
                    type: .Guest
                ),
                Person(
                    id: "2",
                    name: "Test Elemer",
                    type: .Guest
                ),
                Person(
                    id: "3",
                    name: "Elme Bajnok",
                    type: .Guest
                ),
                Person(
                    id: "4",
                    name: "Ember Ember",
                    type: .Guest
                ),
                Person(
                    id: "5",
                    name: "Alma Alma",
                    type: .Guest
                ),
                Person(
                    id: "6",
                    name: "Teszt Teszt",
                    type: .Guest
                )
            ],
            backgroundVariant: .transparent
        )
    }
    
}
