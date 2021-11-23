//
//  ProgramCard.swift
//  hitradio-ios
//
//  Created by Zsolt Oszlányi on 2021. 11. 23..
//

import SwiftUI
import URLImage

struct ProgramCard: View {
    
    var program: Program
    var onClick: () -> Void = {}
    
    var body: some View {
        Button(action: onClick) {
            VStack {
                URLImage(
                    url: URL(string: program.picture)!,
                    content: { image in
                        image
                            .resizable()
                            .centerCropped()
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 16.0))
                    }
                )
                
                Text(program.name)
                    .font(.subheadline)
                    .frame(maxWidth: 100, alignment: .leading)
                    .lineLimit(1)
            }
        }.buttonStyle(PlainButtonStyle())
        
    }
}

struct ProgramCard_Previews: PreviewProvider {
    static var previews: some View {
        ProgramCard(
            program: Program(
                id: "1",
                name: "Test Program",
                picture: "https://images.immediate.co.uk/production/volatile/sites/30/2017/01/Bananas-218094b-scaled.jpg?quality=90&resize=960%2C872",
                description: "This is a test"
            )
        )
        
        ProgramCard(
            program: Program(
                id: "1",
                name: "Test Program loooooooooooooooonnnnnng",
                picture: "https://images.immediate.co.uk/production/volatile/sites/30/2017/01/Bananas-218094b-scaled.jpg?quality=90&resize=960%2C872",
                description: "This is a test"
            )
        )
    }
}
