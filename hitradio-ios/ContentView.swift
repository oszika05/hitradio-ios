import SwiftUI

struct ContentView: View {
    var body: some View {
//        NowPlayingBar(content: Audiotest())
        NowPlayingBar(content: NewsPage())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
