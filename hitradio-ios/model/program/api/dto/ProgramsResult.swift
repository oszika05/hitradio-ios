import Foundation

class ProgramsResult : Codable {
    let schedule: [Day]
    
    init(schedule: [Day]) {
        self.schedule = schedule
    }
    
    enum CodingKeys : String, CodingKey {
        case schedule = "schedule"
    }
}

class Day: Codable {
    let day: String
    let events: [Program]
    
    init(day: String, events: [Program]) {
        self.day = day
        self.events = events
    }
    
    enum CodingKeys : String, CodingKey {
        case day = "day"
        case events = "events"
    }
}
