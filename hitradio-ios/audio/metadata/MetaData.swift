import Foundation

class MetaData {
    let title: String
    let subtitle: String?
    let artUri: String?
    
    let type: String
    
    init (title: String, subtitle: String?, artUri: String?, type: String) {
        self.title = title
        self.subtitle = subtitle
        self.type = type
        self.artUri = artUri
    }
    
    func isLive() -> Bool {
        return self.type == "infinite"
    }
    
//    func artUriOrDefault() -> String {
//        return self.artUri ?? "https://play-lh.googleusercontent.com/vObJFwtpVYL781TFLUhSnSWkVC-IVxhvCZtvQfBvA5sBGFTwgACLwMJy66PpLmnivnAF=s360"
//    }
}

extension Optional where Wrapped: MetaData {
    func artUriOrDefault() -> String {
        if self?.artUri == nil || self?.artUri == "" {
            return "https://play-lh.googleusercontent.com/vObJFwtpVYL781TFLUhSnSWkVC-IVxhvCZtvQfBvA5sBGFTwgACLwMJy66PpLmnivnAF=s360"
        }
        
        return self!.artUri!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
}

extension MetaData {
    func artUriOrDefault() -> String {
        if self.artUri == nil || self.artUri == "" {
            return "https://play-lh.googleusercontent.com/vObJFwtpVYL781TFLUhSnSWkVC-IVxhvCZtvQfBvA5sBGFTwgACLwMJy66PpLmnivnAF=s360"
        }
        
        return self.artUri!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
}

