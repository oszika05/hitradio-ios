import SwiftUI
import URLImage

struct NowPlayingPage: View {
    
    @EnvironmentObject private var metadataRepository: MetadataRepository
//    @EnvironmentObject var radioPlayer: RadioPlayer
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
            
            Text(metadataRepository.songData?.song.title ?? "Podcast title")
                .font(.title)
            
            Text(metadataRepository.songData?.song.artist ?? "Podcast program")
                .font(.body)
            
            Button(action: {
//                if self.radioPlayer.isPlaying {
//                    self.radioPlayer.stop()
//                } else {
//                    self.radioPlayer.play()
//                }
            }) {
//                Text("aa")
                Image(systemName: "stop.fill")
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

