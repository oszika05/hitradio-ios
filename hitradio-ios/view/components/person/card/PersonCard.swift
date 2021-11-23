//
//  PersonItem.swift
//  hitradio-ios
//
//  Created by Zsolt Oszlányi on 2021. 11. 23..
//

import SwiftUI
import URLImage

struct PersonCard: View {
    
    var person: Person
    var onClick: () -> Void = {}
    
    var body: some View {
        Button(action: onClick) {
            VStack(alignment: .center) {
                URLImage(
                    url: URL(string: person.picture ?? "https://media.istockphoto.com/vectors/missing-image-of-a-person-placeholder-vector-id1288129985?k=20&m=1288129985&s=612x612&w=0&h=OHfZHfKj0oqIDMl5f_oRqH13MHiB63nUmySYILbWbjE=")!,
                    content: { image in
                        image
                            .resizable()
                            .centerCropped()
                            .frame(width: 64, height: 64)
                            .clipShape(Circle())
                    }
                )
                
                Text(person.name)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .font(.body)
            }.frame(width: 90)
        }.buttonStyle(PlainButtonStyle())
    }
}

struct PersonCard_Previews: PreviewProvider {
    static var previews: some View {
        PersonCard(
            person: Person(
                id: "1",
                name: "Test Elemer lkdsjflkdas jflkdsj lkdsa",
                type: .Guest
            )
        )
    }
}
