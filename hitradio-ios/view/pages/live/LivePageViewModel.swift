//
//  LivePageViewModel.swift
//  hitradio-ios
//
//  Created by Zsolt Oszlányi on 2021. 10. 21..
//

import Foundation

class LivePageViewModel : ObservableObject, CurrentProgramObserver {
    
    
    private var currentProgramChanger: CurrentProgramChanger? = nil
    
    @Published private(set) var currentProgram: ProgramGuideItem? = nil
    @Published private(set) var programsPerDay: [Int: [ProgramGuideItem]] = [:]
    
    let liveSource: ChanginMetadataSource
    
    init() {
        let programGuideApi = ProgramGuideApi()
        
        liveSource = ChanginMetadataSource(
            id: "LIVE",
            name: "Normal radio",
            programApi: programGuideApi,
            url: SourceUrl(low: "http://stream2.hit.hu:8080/speech", medium: "http://stream2.hit.hu:8080/low", high: "http://stream2.hit.hu:8080/high")
        )
        
        programGuideApi.getPrograms()
            .done { programs in
                print("haha")
                self.currentProgramChanger = CurrentProgramChanger(programs: programs, observer: self, defaultProgram: nil/*ProgramGuideItem.defaultProgram()*/)
            
            }
            .catch { error in
                print(error)
            }
        
        programGuideApi.getProgramsPerDay()
            .done { programsPerDay in
                print("haha 2")
                self.programsPerDay = programsPerDay
            }
            .catch { error in
                print(error)
            }
    }
    
    func onCurrentProgramChange(currentProgram: ProgramGuideItem?) {
        print("joo \(currentProgram?.title ?? "nonne")")
        self.currentProgram = currentProgram
    }
    
}
