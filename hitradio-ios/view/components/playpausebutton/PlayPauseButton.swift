//
//  PlayPauseButton.swift
//  hitradio-ios
//
//  Created by Zsolt Oszlányi on 2021. 11. 22..
//

import SwiftUI

struct HighPriorityButtonStyle: PrimitiveButtonStyle {
    func makeBody(configuration: PrimitiveButtonStyle.Configuration) -> some View {
        MyButton(configuration: configuration)
    }
    
    private struct MyButton: View {
        @State var pressed = false
        let configuration: PrimitiveButtonStyle.Configuration
        
        var body: some View {
            let gesture = DragGesture(minimumDistance: 0)
                .onChanged { _ in self.pressed = true }
                .onEnded { value in
                    self.pressed = false
                    if value.translation.width < 10 && value.translation.height < 10 {
                        self.configuration.trigger()
                    }
                }
            
            return configuration.label
                .opacity(self.pressed ? 0.5 : 1.0)
                .highPriorityGesture(gesture)
        }
    }
}

struct PlayPauseButton: View {
    
    enum ColorVariant {
        case light
        case dark
    }
    
    enum BackgroundVariant {
        case none
        case outline
        case fill
    }
    
    var state: PlaybackState
    var onPlayPauseClick: () -> Void
    var backgroundVariant: BackgroundVariant
    var size: Double
    var innerSize: Double
    var colorVariant: ColorVariant
    
    init(
        state: PlaybackState,
        onPlayPauseClick: @escaping () -> Void,
        backgroundVariant: BackgroundVariant = .none,
        size: Double? = nil,
        innerSize: Double? = nil,
        colorVariant: ColorVariant = .dark
    ) {
        self.state = state
        self.onPlayPauseClick = onPlayPauseClick
        self.backgroundVariant = backgroundVariant
        self.colorVariant = colorVariant
        self.size = size ?? (backgroundVariant == .none ? 18.0 : 64.0)
        self.innerSize = innerSize ?? (backgroundVariant == .none ? 18.0 : 24.0)
    }
    
    var body: some View {
        Button(action: { onPlayPauseClick() }) {
            ZStack {
                
                if backgroundVariant == .fill {
                    Circle()
                        .frame(width: size, height: size)
                        .foregroundColor(Color.primaryColor)
                }
                
                let color = colorVariant == .light ? Color.whiteColor : Color.primaryText
                
                
                switch self.state {
                case .Playing:
                    Image(systemName: "pause.fill")
                        .resizable()
                        .foregroundColor(color)
                        .frame(width: innerSize, height: innerSize)
                case .Stopped:
                    Image(systemName: "play.fill")
                        .resizable()
                        .foregroundColor(color)
                        .frame(width: innerSize, height: innerSize)
                case .Buffering:
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: color))
                        .frame(width: innerSize, height: innerSize)
                }
                
                if backgroundVariant == .outline {
                    Image(systemName: "circle")
                        .resizable()
                        .foregroundColor(color)
                        .frame(width: size, height: size)
                }
                
                
            }
            .frame(width: size, height: size)
        }
        .buttonStyle(HighPriorityButtonStyle())
        
        
        
    }
}

struct PlayPauseButton_Previews: PreviewProvider {
    static var previews: some View {
        PlayPauseButton(
            state: PlaybackState.Stopped,
            onPlayPauseClick: {  }
        )
        
        PlayPauseButton(
            state: PlaybackState.Playing,
            onPlayPauseClick: {  }
        )
        
        PlayPauseButton(
            state: PlaybackState.Buffering,
            onPlayPauseClick: {  }
        )
        
        PlayPauseButton(
            state: PlaybackState.Stopped,
            onPlayPauseClick: {  },
            backgroundVariant: .outline
        )
        
        PlayPauseButton(
            state: PlaybackState.Stopped,
            onPlayPauseClick: {  },
            backgroundVariant: .fill,
            colorVariant: .light
        )
        
        PlayPauseButton(
            state: PlaybackState.Buffering,
            onPlayPauseClick: {  },
            backgroundVariant: .fill,
            colorVariant: .light
        )
    }
}
