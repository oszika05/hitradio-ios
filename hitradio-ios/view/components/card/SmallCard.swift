//
//  SmallCard.swift
//  hitradio-ios
//
//  Created by Zsolt Oszlányi on 2021. 11. 22..
//

import SwiftUI
import URLImage

struct SmallCard: View {
    
    enum BackgroundVariant {
        case white
        case grey
    }
    
    var title: String
    var subtitle: String? = nil
    var picture: String
    var playbackState: PlaybackState? = nil
    var onClick: () -> Void = {}
    var onPlayPauseClick: () -> Void = {}
    var backgroundVariant: BackgroundVariant = .white
    
    
    var body: some View {
        Button(action: { onClick() }) {
            ZStack {
                
                let cardColor = backgroundVariant == .white ? Color.whiteColor : Color.greyColor
                
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .foregroundColor(cardColor)
                    .boxShadow(enabled: backgroundVariant == .white)
                
                HStack(alignment: .top, spacing: 0.0) {
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
                                colorVariant: .light
                            )
                        }
                        
                    }
                    .frame(width: 64, height: 64)
                    .clipShape(RoundedRectangle(cornerRadius: 8.0))
                    .clipped()
                    .padding(.leading, 16.0)
                    .padding(.trailing, 8.0)
                    .padding(.vertical, 8.0)
                    
                    
                    VStack(alignment: .leading) {
                        Text(title)
                            .font(.body)
                            .lineLimit(3)
                            .foregroundColor(Color.primaryText)
                            .padding(.top, 8.0)
                            .padding(.bottom, 4.0)
                            .padding(.trailing, 16.0)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        if subtitle != nil {
                            Text(subtitle!)
                                .lineLimit(1)
                                .font(.caption)
                                .foregroundColor(Color.secondaryText)
                                .padding(.trailing, 16.0)
                                .padding(.bottom, 4.0)
                        }
                        
                        ZStack {
                            // bottom padding
                        }.frame(height: 4.0)
                    }
                }.layoutPriority(1.0)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                    )
            }
        }
        .buttonStyle(PlainButtonStyle())
    
        
        
    }
}

struct SmallCard_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            SmallCard(
                title: "This is a test This is a test This is a test",
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
        
        
        SmallCard(
            title: "This is a test",
            subtitle: "Kozeppont",
            picture: "https://images.immediate.co.uk/production/volatile/sites/30/2017/01/Bananas-218094b-scaled.jpg?quality=90&resize=960%2C872",
            playbackState: .Buffering
        )
        
        SmallCard(
            title: "This is a test This is a test This is a test This is a test",
            subtitle: "Kozeppont",
            picture: "https://images.immediate.co.uk/production/volatile/sites/30/2017/01/Bananas-218094b-scaled.jpg?quality=90&resize=960%2C872",
            playbackState: .Buffering
        )
        
        SmallCard(
            title: "This is a test This is a test This is a test This is a test This is a test This is a test This is a test This is a test This is a test This is a test This is a test This is a test This is a test This is a test This is a test  This is a test This is a test This is a test This is a test This is a test This is a test This is a test This is a test This is a test",
            subtitle: "Kozeppont",
            picture: "https://images.immediate.co.uk/production/volatile/sites/30/2017/01/Bananas-218094b-scaled.jpg?quality=90&resize=960%2C872",
            playbackState: .Buffering,
            backgroundVariant: .grey
        )
    }
}
