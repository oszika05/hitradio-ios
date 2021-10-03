import SwiftUI


struct Audiotest: View {
    
    @EnvironmentObject private var audioState: AudioController
    @ObservedObject private var audiotestModel = AudiotestModel()
    
    var body: some View {
        
        VStack {
            
            Button(action: {
                self.audioState.setSource(source: ChanginMetadataSource(
                    id: "1", name: "Normal radio", programApi: audiotestModel.programApi, url: SourceUrl(low: "http://stream2.hit.hu:8080/speech", medium: "http://stream2.hit.hu:8080/low", high: "http://stream2.hit.hu:8080/high")
                ))
            }) {
                Text("set source #1")
            }
            
            Button(action: {
                self.audioState.setSource(source: SimpleSource(
                    id: "2", name: "Podcast test", metadata: MetaData(
                        title: "Podcast title", subtitle: "subtitle", artUri: "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ab/Patates.jpg/2560px-Patates.jpg", type: "simple"
                    ), url: SourceUrl(url: "https://www.kozco.com/tech/organfinale.mp3")
                ))
            }) {
                Text("set source #2")
            }
            
            Button(action: {
                self.audioState.setSource(source: nil)
            }) {
                Text("set no source")
            }
            
            Button(action: {
                self.audioState.playPause()
            }) {
                Text(self.audioState.isPlaying ? "Stop" : "Play")
            }
            
            Text(self.audioState.metadata?.title ?? "no metadata")
            
            if (self.audiotestModel.programs.count > 3) {
                List(self.audiotestModel.programs[0...2], id: \.id) { program in
                    Text(program.title)
                }
            }
        }.onAppear {
            self.audiotestModel.loadPrograms()
        }
    }
}

struct Audiotest_Previews: PreviewProvider {
    static var previews: some View {
        let audioController = AudioController(player: AudioPlayer())
        
        Audiotest()
            .environmentObject(audioController)
    }
}

