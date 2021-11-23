//
//  LivePage.swift
//  hitradio-ios
//
//  Created by Zsolt Oszlányi on 2021. 10. 21..
//

import SwiftUI

struct LivePage: View {
    @ObservedObject private var viewModel = LivePageViewModel()
    @EnvironmentObject private var audioController: AudioController
    
    var body: some View {
        let isCurrentSource = audioController.getSource()?.id == viewModel.liveSource.id
        let isPlaying = isCurrentSource && (audioController.playbackState != .Stopped)
        
        VStack {
            Text(viewModel.currentProgram?.title ?? "")
            Button(action: {
                
                if (!isCurrentSource) {
                    audioController.setSource(source: viewModel.liveSource)
                } else {
                    audioController.playPause()
                }
            }) {
                Text(isPlaying ? "pause" : "play")
            }
            
            ForEach(Array(viewModel.programsPerDay.keys), id: \.self) { day in
                Text("day \(day), programs: \(viewModel.programsPerDay[day]?.count ?? 0)")
            }
            
            Spacer()
        }
        
    }
}

struct LivePage_Previews: PreviewProvider {
    static var previews: some View {
        LivePage()
    }
}
