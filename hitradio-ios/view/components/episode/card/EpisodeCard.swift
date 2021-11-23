//
//  EpisodeCard.swift
//  hitradio-ios
//
//  Created by Zsolt Oszlányi on 2021. 11. 23..
//

import SwiftUI

struct EpisodeCard: View {
    
    var episode: Episode
    var playbackState: PlaybackState
    var onClick: () -> Void
    var onPlayPauseClick: () -> Void
    
    var body: some View {
        Card(
            title: episode.title,
            subtitle: episode.program.name,
            picture: episode.program.picture,
            playbackState: playbackState,
            onClick: onClick,
            onPlayPauseClick: onPlayPauseClick,
            sizeVariant: .fullWidth
        )
    }
}

struct EpisodeCard_Previews: PreviewProvider {
    static var previews: some View {
        EpisodeCard(
            episode: Episode(
                id: "1",
                title: "This is test episode",
                date: Date(),
                description: nil,
                tags: [],
                program: Program(
                    id: "1",
                    name: "Program",
                    picture: "https://images.immediate.co.uk/production/volatile/sites/30/2017/01/Bananas-218094b-scaled.jpg?quality=90&resize=960%2C872"
                ),
                audioUrl: "aa",
                hosts: [],
                guests: []
            ),
            playbackState: .Stopped,
            onClick: {},
            onPlayPauseClick: {}
        )
    }
}
