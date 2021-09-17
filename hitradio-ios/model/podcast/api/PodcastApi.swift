import Foundation
import Alamofire
import PromiseKit
import Combine

class PodcastApi {
    private let decoder = JSONDecoder()
    
    init() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.timeZone = .none
        self.decoder.dateDecodingStrategy = .formatted(formatter)
    }
    
    func getPodcastPrograms(pagination: PodcastApi.Pagination) -> Promise<[PodcastProgram]> {
        return Promise { seal in
            AF
                .request("http://192.168.2.22:8081/program?skip=\(pagination.skip)&pageSize=\(pagination.pageSize)")
                .responseDecodable(of: [PodcastProgram].self, decoder: self.decoder) { response in
                    if response.error == nil {
                        seal.fulfill(response.value ?? [])
                    } else {
                        seal.reject(response.error!.underlyingError!)
                    }
                }
        }
    }
    
    func getPodcastItems(programId: Int?, pagination: PodcastApi.Pagination) -> Promise<[PodcastItem]> {
        return Promise { seal in
            AF
                .request("http://192.168.2.22:8081/program/\(programId != nil ? "\(programId!)" : "all")?skip=\(pagination.skip)&pageSize=\(pagination.pageSize)")
                .responseDecodable(of: [PodcastItem].self, decoder: self.decoder) { response in
                    if response.error == nil {
                        seal.fulfill(response.value ?? [])
                    } else {
                        seal.reject(response.error!.underlyingError!)
                    }
                }
        }
    }
    
    class Pagination {
        var skip: Int
        var pageSize: Int
        
        init(skip: Int, pageSize: Int) {
            self.skip = skip
            self.pageSize = pageSize
        }
    }
}


