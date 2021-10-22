import Foundation
import Alamofire
import PromiseKit
import Combine

class ProgramGuideApi {
    private let decoder = JSONDecoder()
    
    private let url: String
    
    init(url: String = "https://www.hitradio.hu/api/musor_ios.php") {
        self.url = url
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        self.decoder.dateDecodingStrategy = .formatted(formatter)
    }
    
    private func changeDayOfDate(date: Date, day: Int, startDate: Date? = nil) -> Date? {
        var components = Calendar.current.dateComponents([.hour, .minute, .weekday], from: date)
        
        var diff = day - (components.weekday! + 1)
        
        if diff < -3 {
            diff += 7
        }
        
        if diff >= 4 {
            diff -= 7
        }
        
        var dayComponent    = DateComponents()
        dayComponent.day    = diff
        
        let todayParts = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        
        components.year = todayParts.year
        components.month = todayParts.month
        components.day = todayParts.day
        components.second = 0
        
        
        var d = Calendar.current.date(from: components)
        
        if d == nil {
            return nil
        }
        
        if startDate != nil {
            if d! <= startDate! {
                let startDateComponents = Calendar.current.dateComponents([.day, .hour], from: startDate!)
                
                components.day! = startDateComponents.day!
                
                d = Calendar.current.date(from: components)
                
                
                if d! <= startDate! {
                    components.day! += 1
                    d = Calendar.current.date(from: components)
                }
            }
        }
        
        
        return Calendar.current.date(
            byAdding: dayComponent,
            to: d!
        )
    }
    
    private func convertProgramResultToArray(programsResult: ProgramGuideResult) -> [ProgramGuideItem] {
        programsResult.schedule.enumerated().reduce([]) { programs, day in
            var normalizedDay = day
            if normalizedDay.offset == 0 {
                normalizedDay.offset = 7
            }
            
            let programsInDay = day.element.events
                .map { program in
                    
                    let startDate = changeDayOfDate(date: program.start, day: normalizedDay.offset)
                    let endDate = changeDayOfDate(date: program.end, day: normalizedDay.offset, startDate: startDate)
                    
                    return (program, startDate, endDate)
                }
                .filter { program, startDate, endDate in
                    return startDate != nil && endDate != nil
                }
                .map { program, startDate, endDate in
                    return ProgramGuideItem(from: program, start: startDate!, end: endDate!)
                }
            
            return programs + programsInDay
        }
    }
    
    func getPrograms() -> Promise<[ProgramGuideItem]> {
        return Promise { seal in
            AF
                .request("https://www.hitradio.hu/api/musor_ios.php")
                .responseDecodable(of: ProgramGuideResult.self, decoder: self.decoder) { response in
                    if response.error == nil {
                        let programsResult = response.value ?? nil
                        
                        if programsResult == nil {
                            seal.fulfill([])
                            return
                        }
                        
                        let programs = self.convertProgramResultToArray(programsResult: programsResult!)
                        
                        seal.fulfill(programs)
                    } else {
                        print("error in programs")
                        seal.reject(response.error!.underlyingError!)
                    }
                }
        }
    }
    
    func getProgramsPerDay() -> Promise<[Int: [ProgramGuideItem]]> {
        let programsRequest = self.getPrograms()

        return programsRequest
            .map { programs in
                var newProgramsPerDay: [Int: [ProgramGuideItem]] = [0: [], 1: [], 2: [], 3: [], 4: [], 5: [], 6: [], 7: []]
                for program in programs {
                    let components = Calendar.current.dateComponents([.weekday], from: program.start)
                    let weekday = components.weekday ?? 0
                    
                    if !newProgramsPerDay.contains(where: { key, value in key == weekday }) {
                        newProgramsPerDay[weekday] = []
                    }
                    
                    newProgramsPerDay[weekday]?.append(program)
                }
                
                return newProgramsPerDay
            }
    }
}
