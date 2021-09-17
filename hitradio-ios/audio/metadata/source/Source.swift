import Foundation

protocol Source {
    var id: String { get }
    var name: String { get }
    var metadata: MetaData { get }
    var url: SourceUrl { get }
    
    func subscribe(observer: MetadataObserver)
}
