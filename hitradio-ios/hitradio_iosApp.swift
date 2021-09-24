import SwiftUI
import AVFoundation

@main
struct hitradio_iosApp: App {
    @UIApplicationDelegateAdaptor var delegate: AppDelegate
    
    var body: some Scene {
        let metadataRepository = MetadataRepository()
        let audioController = AudioController(player: AudioPlayer())
        
        WindowGroup {
            ContentView()
                .environmentObject(metadataRepository)
                .environmentObject(audioController)
        }
    }
}
