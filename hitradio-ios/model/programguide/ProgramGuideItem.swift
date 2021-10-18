import Foundation

class ProgramGuideItem: Codable {
    let id: String
    let title: String
    let start: Date
    let end: Date
    let description: String
    let replay: String
    
    init(id: String, title: String, start: Date, end: Date, description: String, replay: String) {
        self.id = id
        self.title = title
        self.start = start
        self.end = end
        self.description = description
        self.replay = replay
    }
    
    init (from: ProgramGuideItem, start: Date, end: Date) {
        self.id = from.id
        self.title = from.title
        self.start = start
        self.end = end
        self.description = from.description
        self.replay = from.replay
    }
    
    func getInterval() -> DateInterval {
        return DateInterval(start: self.start, end: self.end)
    }
    
    func isProgramPlaying() -> Bool {
        self.getInterval().contains(Date())
    }
    
    func withTimes(start: Date, end: Date) -> ProgramGuideItem {
        return ProgramGuideItem(from: self, start: start, end: end)
    }
    
    enum CodingKeys : String, CodingKey {
        case id = "show_id"
        case title = "show_title"
        case start = "show_time"
        case end = "show_time_end"
        case description = "show_description"
        case replay = "show_replay"
    }
}
