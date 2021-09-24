import SwiftUI
import URLImage

struct NowPlayingPage: View {
    
    @EnvironmentObject private var metadataRepository: MetadataRepository
//    @EnvironmentObject var radioPlayer: RadioPlayer
    @EnvironmentObject private var audioState: AudioController
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            RoundedRectangle(
                cornerRadius: 6.0,
                style: .continuous
            )
            .fill(Color.gray)
            .frame(width: 40, height: 7.5)
            
            
            Spacer()
            
            ZStack {
                RoundedRectangle(
                    cornerRadius: 15.0,
                    style: .continuous
                )
                .fill(Color(UIColor.systemBackground))
                .shadow(radius: 10)
                
                URLImage(url: URL(string: "https://play-lh.googleusercontent.com/vObJFwtpVYL781TFLUhSnSWkVC-IVxhvCZtvQfBvA5sBGFTwgACLwMJy66PpLmnivnAF=s360")!,
                         content: { image in
                            image
                                .resizable()
                                .scaledToFit()
//                                .aspectRatio(contentMode: .fill)
                                .padding(25)
                         }
                ).layoutPriority(10)
            }
            .padding(.bottom, 24)
            .padding(.horizontal, 10)
            
            Text(self.audioState.metadata?.title ?? "")
                .font(.title)

            Text(self.audioState.metadata?.subtitle ?? "")
                .font(.body)
            
            Button(action: {
                self.audioState.playPause()
            }) {
//                Text("aa")
                Image(systemName: self.audioState.isPlaying ? "stop.fill" : "play.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .padding()
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.bottom, 16)
            
            VolumeSlider()
                .frame(height: 40)
        }
        .padding(.horizontal, 32)
        .padding(.vertical, 16)
    }
}

struct NowPlayingPage_Previews: PreviewProvider {
    
    static let metadataRepository = MetadataRepository()
//    static let radioPlayer = RadioPlayer()
    
    static var previews: some View {
        NowPlayingPage()
            .environmentObject(metadataRepository)
//            .environmentObject(radioPlayer)
    }
}

