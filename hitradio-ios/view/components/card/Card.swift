//
//  Card.swift
//  hitradio-ios
//
//  Created by Zsolt Oszlányi on 2021. 11. 22..
//

import SwiftUI
import URLImage

struct Card: View {
    
    enum SizeVariant {
        case fullWidth
        case small
    }
    
    var title: String
    var subtitle: String? = nil
    var picture: String
    var playbackState: PlaybackState? = nil
    var onClick: () -> Void = {}
    var onPlayPauseClick: () -> Void = {}
    var sizeVariant: SizeVariant = .fullWidth
    
    
    var body: some View {
        Button(action: { onClick() }) {
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .foregroundColor(Color.whiteColor)
                    .boxShadow()
                
                VStack(alignment: .leading, spacing: 0.0) {
                    ZStack {
                        URLImage(
                            url: URL(string: picture)!,
                            content: { image in
                                image
                                    .centerCropped()
                            }
                        )
                        
                        if playbackState != nil {
                            PlayPauseButton(
                                state: playbackState!,
                                onPlayPauseClick: onPlayPauseClick,
                                backgroundVariant: .outline,
                                colorVariant: .light
                            )
                        }
                       
                    }
                    .aspectRatio(1.77, contentMode: .fit)
                    .clipped()
                    
                    
                    Text(title)
                        .font(.body)
                        .foregroundColor(Color.primaryText)
                        .padding(.top, 8.0)
                        .padding(.horizontal, 16.0)
                    
                    if subtitle != nil {
                        Text(subtitle!.uppercased())
                            .lineLimit(2)
                            .font(.footnote)
                            .foregroundColor(Color.secondaryText)
                            .padding(.top, 4.0)
                            .padding(.horizontal, 16.0)
                    }
                    
                    ZStack {
                        // bottom spacing
                    }.padding(.top, 16.0)
                }.layoutPriority(1.0)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                    )
            }
        }
        .buttonStyle(PlainButtonStyle())
        .frame(width: (sizeVariant == .fullWidth) ? .infinity : 311.0)
    }
}

struct Card_Previews: PreviewProvider {
    
    static var previews: some View {
        ZStack {
            Card(
                title: "This is a test",
                picture: "https://images.immediate.co.uk/production/volatile/sites/30/2017/01/Bananas-218094b-scaled.jpg?quality=90&resize=960%2C872",
                playbackState: .Stopped,
                onClick: {
                    print("onClick")
                },
                onPlayPauseClick: {
                    print("onPlayPauseClick")
                }
            )
        }.padding(16.0)
        
        
        Card(
            title: "This is a test",
            subtitle: "Kozeppont",
            picture: "https://images.immediate.co.uk/production/volatile/sites/30/2017/01/Bananas-218094b-scaled.jpg?quality=90&resize=960%2C872",
            playbackState: .Buffering,
            sizeVariant: .small
        )
    }
}
