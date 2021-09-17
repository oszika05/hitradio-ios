import Foundation

class SourceUrl {
    private let sources: Dictionary<StreamQuality, String>
    
    init(low: String, medium: String, high: String) {
        self.sources = [
            StreamQuality.Low: low,
            StreamQuality.Medium: medium,
            StreamQuality.High: high
        ]
    }
    
    init(url: String) {
        self.sources = [
            StreamQuality.Low: url,
            StreamQuality.Medium: url,
            StreamQuality.High: url
        ]
    }
    
    func get(quality: StreamQuality) -> String {
        return self.sources[quality]!
    }
}
