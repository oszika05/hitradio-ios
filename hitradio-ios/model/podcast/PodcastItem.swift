import Foundation

class PodcastItem: Decodable {
    let id: Int
    let name: String
    let description: String?
    let date: Date?
    let fileUrl: String
    let programName: String
    let length: String
    
    init(id: Int, name: String, description: String?, date: Date?, fileUrl: String, programName: String, length: String) {
        self.id = id
        self.name = name
        self.description = description
        self.date = date
        self.fileUrl = fileUrl
        self.programName = programName
        self.length = length
    }
}
