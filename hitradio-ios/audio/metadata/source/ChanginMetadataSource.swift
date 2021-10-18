import Foundation

class ChanginMetadataSource : Source, CurrentProgramObserver {
    private var observers: [MetadataObserver] = []
    
    private let _id: String
    private let _name: String
    private var _metadata: MetaData
    private let _url: SourceUrl
    
    private var currentProgramChanger: CurrentProgramChanger?
    
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
    
    init(id: String, name: String, programApi: ProgramGuideApi, url: SourceUrl) {
        self._id = id
        self._name = name
        self._metadata = MetaData(title: name, subtitle: nil, artUri: nil, type: "infinite")
        self._url = url
        
        self.currentProgramChanger = nil
        
        programApi.getPrograms()
            .done { programs in
                self.currentProgramChanger = CurrentProgramChanger(programs: programs, observer: self)
            }
    }
    
    func subscribe(observer: MetadataObserver) {
        observers.append(observer)
        observer.onMetadataChanged(metadata: _metadata)
    }
    
    func onCurrentProgramChange(currentProgram: ProgramGuideItem?) {
        self._metadata = MetaData(
            title: currentProgram?.title ?? "",
            subtitle: self._name,
            artUri: nil, // TODO!
            type: "infinite"
        )
        
        for observer in self.observers {
            observer.onMetadataChanged(metadata: self._metadata)
        }
    }
}
