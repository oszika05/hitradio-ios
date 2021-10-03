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
        let task = URLSession.shared.dataTask(with: URL(string: image)!) { (data, response, error) in
            let downloadedImage = UIImage(data: data!)

            onDownloaded(downloadedImage)
        }

        task.resume()
    }

    private func constructDurationInfo(
        existingInfo: [String: Any],
        progress: Double,
        duration: Double
    ) -> [String: Any] {
        var nowPlayingInfo = existingInfo

        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = progress
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = duration
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 1.0
        
        return nowPlayingInfo
    }

    private func constructMetadataInfo(
        existingInfo: [String: Any],
        metadata: MetaData, image: UIImage?
    ) -> [String: Any] {
        var nowPlayingInfo = existingInfo
        nowPlayingInfo[MPMediaItemPropertyTitle] = "My Song"

        nowPlayingInfo[MPNowPlayingInfoPropertyIsLiveStream] = metadata.isLive()
        nowPlayingInfo[MPMediaItemPropertyTitle] = metadata.title
        nowPlayingInfo[MPMediaItemPropertyArtist] = metadata.subtitle
        if image != nil {
            nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image!.size, requestHandler: { size in
                return image!
            })
        }

        if !metadata.isLive() {
            nowPlayingInfo[MPMediaItemPropertyPodcastTitle] = metadata.title
        }

        return nowPlayingInfo
    }

    private func applyMetadataToSystem(nowPlayingInfo: [String: Any]) {
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }

    func updateProgress(progress: Double, duration: Double) {
        let nowPlayingInfo = self.constructDurationInfo(
            existingInfo: self.nowPlayingInfo,
            progress: progress,
            duration: duration
        )
        self.nowPlayingInfo = nowPlayingInfo
        self.applyMetadataToSystem(nowPlayingInfo: nowPlayingInfo)
    }

    func updateMetadata(metadata: MetaData) {
        let nowPlayingInfoWithDefaultImage = self.constructMetadataInfo(
            existingInfo: self.nowPlayingInfo,
            metadata: metadata,
            image: nil
        )
        self.applyMetadataToSystem(nowPlayingInfo: nowPlayingInfoWithDefaultImage)
        self.nowPlayingInfo = nowPlayingInfoWithDefaultImage

        if metadata.artUri != nil {
            self.downloadImage(image: metadata.artUri!) { image in
                let nowPlayingInfo = self.constructMetadataInfo(
                    existingInfo: self.nowPlayingInfo,
                    metadata: metadata,
                    image: image
                )
                self.applyMetadataToSystem(nowPlayingInfo: nowPlayingInfo)
                self.nowPlayingInfo = nowPlayingInfoWithDefaultImage
            }
        }

        // Set the metadata
//        MPNowPlayingInfoCenter.default().playbackState = .playing
    }
}
