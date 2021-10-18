import Foundation
import Combine

class CurrentProgramChanger {
    var timer : Timer!
    let programs: [ProgramGuideItem]
    
    private let observer: CurrentProgramObserver
    private let defaultProgram: ProgramGuideItem
    
    init(programs: [ProgramGuideItem], observer: CurrentProgramObserver, defaultProgram: ProgramGuideItem? = nil) {
        self.programs = programs
        self.observer = observer
    
        if defaultProgram != nil {
            self.defaultProgram = defaultProgram!
        } else {
            self.defaultProgram = ProgramGuideItem(
                id: "0",
                title: "Zene",
                start: Date(),
                end: Date(),
                description: "",
                replay: ""
            )
        }
        
        let currentProgram = getCurrentProgram()
        
        observer.onCurrentProgramChange(currentProgram: currentProgram)
        
        setTimerForNextEvent()
    }
    
    deinit {
        timer?.invalidate()
    }
    
    private func getCurrentProgram() -> ProgramGuideItem? {
        let currentTime = Date()

        return programs.sorted { (a: ProgramGuideItem, b: ProgramGuideItem) in
            // sort by dates asc
            return b.start.compare(a.start).rawValue > 0
        }.filter { program in
            // programs, that end after now
            program.end.compare(currentTime).rawValue > 0
        }.first
    }
    
    private func getNextProgram() -> ProgramGuideItem? {

        // add 2 seconds to the time to avoid
        let currentTime = Date().addingTimeInterval(2.0)

        return self.fillGaps(programs: programs).sorted { (a: ProgramGuideItem, b: ProgramGuideItem) in
            // sort by dates asc
            return b.start.compare(a.start).rawValue > 0
        }.filter { program in
            // programs after now
            program.start.compare(currentTime).rawValue > 0
        }.first
    }
    
    private func fillGaps(programs: [ProgramGuideItem]) -> [ProgramGuideItem] {
        var newPrograms = [ProgramGuideItem]()
        
        for program in programs {
            let lastProgramEnd = newPrograms.last?.end
            
            if lastProgramEnd != nil && lastProgramEnd!.compare(program.start).rawValue < 0 {
                newPrograms.append(
                    self.defaultProgram.withTimes(start: lastProgramEnd!, end: program.start)
                )
            }
            
            newPrograms.append(program)
        }
        
        return newPrograms
    }
    
    private func setTimerForNextEvent() {
        let nextProgram = self.getNextProgram()
        if nextProgram != nil {
            setTimer(for: nextProgram!)
        }
    }
    
    private func setTimer(for program: ProgramGuideItem) {
        self.timer?.invalidate()
        let timeToStart = Date().distance(to: program.start)
        self.timer = Timer.scheduledTimer(withTimeInterval: timeToStart, repeats: false) { _ in
            print("onprogramchange: program: \(program.title) start: \(program.start)")

            self.observer.onCurrentProgramChange(currentProgram: program)
            
            self.setTimerForNextEvent()
        }
    }
}
