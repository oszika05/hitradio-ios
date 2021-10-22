//
//  SystemMetadataUpdater.swift
//  hitradio-ios
//
//  Created by Zsolt Oszlányi on 2021. 10. 03..
//

import Foundation
import MediaPlayer


class SystemMetadataUpdater {

    private var nowPlayingInfo: [String: Any] = [String: Any]()

    private func downloadImage(image: String, _ onDownloaded: @escaping (_: UIImage?) -> Void) {
        if URL(string: image) == nil {
            onDownloaded(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: URL(string: image)!) { (data, response, error) in
            let downloadedImage = UIImage(data: data!)

            onDownloaded(downloadedImage)
        }

        task.resume()
    }

    private func constructDurationInfo(
        progress: Double,
        duration: Double
    ) -> [String: Any] {
        var nowPlayingInfo = [String: Any]()

        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = progress
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = duration
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 1.0

        return nowPlayingInfo
    }

    private func constructMetadataInfo(
        metadata: MetaData, image: UIImage?
    ) -> [String: Any] {
        var nowPlayingInfo = [String: Any]()

        nowPlayingInfo[MPNowPlayingInfoPropertyIsLiveStream] = metadata.isLive()
        nowPlayingInfo[MPMediaItemPropertyTitle] = metadata.title
        nowPlayingInfo[MPMediaItemPropertyArtist] = metadata.subtitle
        if image != nil {
            nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image!.size, requestHandler: { size in
                return image!
            })
        }

        return nowPlayingInfo
    }
    
    private func patchSystemMetadata(patch: [String: Any]) {
        self.nowPlayingInfo.merge(patch) { (_, new) in new }
        self.applyMetadataToSystem(nowPlayingInfo: self.nowPlayingInfo)
    }

    private func applyMetadataToSystem(nowPlayingInfo: [String: Any]) {
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }

    func updateProgress(progress: Double, duration: Double) {
        let nowPlayingInfo = self.constructDurationInfo(
            progress: progress,
            duration: duration
        )
        self.patchSystemMetadata(patch: nowPlayingInfo)
    }

    func updateMetadata(metadata: MetaData) {
        let nowPlayingInfoWithDefaultImage = self.constructMetadataInfo(
            metadata: metadata,
            image: nil
        )
        self.patchSystemMetadata(patch: nowPlayingInfoWithDefaultImage)

        if metadata.artUri != nil {
            self.downloadImage(image: metadata.artUriOrDefault()) { image in
                let nowPlayingInfo = self.constructMetadataInfo(
                    metadata: metadata,
                    image: image
                )
                self.patchSystemMetadata(patch: nowPlayingInfo)
            }
        }

        // Set the metadata
//        MPNowPlayingInfoCenter.default().playbackState = .playing
    }
}
