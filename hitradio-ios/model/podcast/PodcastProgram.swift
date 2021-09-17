import Foundation

class PodcastProgram: Decodable {
    let id: Int
    let name: String
    let description: String?
    let itemCount: Int
    
    init(id: Int, name: String, description: String?, itemCount: Int) {
        self.id = id
        self.name = name
        self.description = description
        self.itemCount = itemCount
    }
}
