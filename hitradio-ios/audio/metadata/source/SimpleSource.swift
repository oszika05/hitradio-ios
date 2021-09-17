import Foundation

class SimpleSource : Source {
    private let _id: String
    private let _name: String
    private let _metadata: MetaData
    private let _url: SourceUrl
    
    
    var id: String {
        get {
            return _id
        }
    }
    
    var name: String {
        get {
            return _name
        }
    }
    
    var metadata: MetaData {
        get {
            return _metadata
        }
    }
    
    var url: SourceUrl {
        get {
            return _url
        }
    }
    
    init(id: String, name: String, metadata: MetaData, url: SourceUrl) {
        self._id = id
        self._name = name
        self._metadata = metadata
        self._url = url
    }
    
    func subscribe(observer: MetadataObserver) {
        observer.onMetadataChanged(metadata: self._metadata)
    }
}

