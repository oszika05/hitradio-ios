import Foundation

class AudiotestModel: ObservableObject {
    
    @Published private(set) var programs: [ProgramGuideItem] = []
    
    let programApi = ProgramGuideApi(url: "https://www.hitradio.hu/api/musor_ios.php")
    
    func loadPrograms() {
        self.programApi.getPrograms()
            .done { programs in
                self.programs = programs
            }
            .catch { error in
                print(error)
            }
    }
    
    
}
