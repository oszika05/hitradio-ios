import SwiftUI
import URLImage

let nowPlayingBarHeigth: CGFloat = 65

// https://play-lh.googleusercontent.com/vObJFwtpVYL781TFLUhSnSWkVC-IVxhvCZtvQfBvA5sBGFTwgACLwMJy66PpLmnivnAF=s360


struct NowPlayingBar<Content: View>: View {
    var content: Content

//    @EnvironmentObject private var radioPlayer: RadioPlayer
    @EnvironmentObject private var metadataRepository: MetadataRepository
    @EnvironmentObject private var audioState: AudioController

    @State private var showMediaPlayer = false

    @ViewBuilder
    var body: some View {

        ZStack(alignment: .bottom) {
            VStack() {
                content.padding(.bottom, nowPlayingBarHeigth)
            }

            Button(action: {
                self.showMediaPlayer.toggle()
            }) {
                ZStack {
                    Rectangle()
                        .foregroundColor(Color.white.opacity(0.0))
                        .frame(width: UIScreen.main.bounds.size.width, height: nowPlayingBarHeigth)
                        .background(Blur())

                    HStack {
                        ZStack {
                            RoundedRectangle(
                                cornerRadius: 3,
                                style: .continuous
                            )
                                .fill(Color(UIColor.systemBackground))
                                .shadow(radius: 2)

                            URLImage(
                                url: URL(string: self.audioState.metadata.artUriOrDefault())!,
                                content: { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .padding(8.0)
                                        .frame(width: 45, height: 45)
                                }
                            ).layoutPriority(15)
                        }
                            .padding(.leading, 24)


                        VStack(alignment: .leading) {
                            Text(
                                self.audioState.metadata?.title ?? ""
                            )
                                .multilineTextAlignment(.leading)
                                .lineLimit(1)

                            Text(
                                self.audioState.metadata?.subtitle ?? ""
                            )
                                .multilineTextAlignment(.leading)
                                .font(.caption)
                                .lineLimit(1)

                        }.padding(.leading, 6)

                        Spacer()

                        Button(action: {
                            print("play button pressed")
                            self.audioState.playPause()
                        }) {
//                            Text("aaa")
                            Image(
                                systemName: self.audioState.isPlaying ? "stop.fill" : "play.fill"
                            )
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .padding(8.0)
                                .padding(.trailing, 16)
                        }
                            .buttonStyle(PlainButtonStyle())


                    }.padding(0)
                }
            }
                .buttonStyle(PlainButtonStyle())
        }
            .sheet(isPresented: $showMediaPlayer) {
            NowPlayingPage()
        }
    }
}

struct NowPlayingBar_Previews: PreviewProvider {

    static let metadataRepository = MetadataRepository()
//    static let radioPlayer = RadioPlayer()



    static var previews: some View {
        NowPlayingBar(content: EmptyView())
            .environmentObject(metadataRepository)
//            .environmentObject(radioPlayer)
    }
}
