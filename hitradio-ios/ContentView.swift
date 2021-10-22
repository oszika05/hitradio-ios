import SwiftUI
import SwiftUIRouter

struct ContentView: View {
    var body: some View {
        
        TabView {
            NowPlayingBar(content: NavigationView {
                HomePage()
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
            })
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            NowPlayingBar(content: NavigationView {
                LivePage()
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
            })
                .tabItem {
                    Label("Live", systemImage: "dot.radiowaves.left.and.right")
                }
            
            NowPlayingBar(content: NavigationView {
                DiscoverPage()
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
            })
                .tabItem {
                    Label("Discover", systemImage: "magnifyingglass")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
