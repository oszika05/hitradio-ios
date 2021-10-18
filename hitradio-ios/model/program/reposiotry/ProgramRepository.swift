//
//  ProgramApi.swift
//  hitradio-ios
//
//  Created by Zsolt Oszlányi on 2021. 10. 12..
//

import Foundation
import Combine

class ProgramRepository {

    private func generateUrl(path: String, queryItems: [URLQueryItem]) -> URL {
        var components = URLComponents()

        components.scheme = "https"
        components.host = "hitradio-mock.herokuapp.com"
        components.path = path
        components.queryItems = queryItems

        return components.url!
    }
    
    func getProgram(id: String) -> AnyPublisher<Program, Error> {
        return AnyPublisher(
            URLSession.shared.dataTaskPublisher(for: self.generateUrl(path: "/program/\(id)", queryItems: []))
                .tryMap { $0.data }
                .decode(type: Program.self, decoder: JSONDecoder())
        )
    }

    func getPrograms(from: Int, pageSize: Int, search: String?) -> AnyPublisher<[Program], Error> {
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "from", value: "\(from)"),
            URLQueryItem(name: "pageSize", value: "\(pageSize)"),
        ]

        if search?.isEmpty == false {
            queryItems.append(URLQueryItem(name: "search", value: search!))
        }

        return AnyPublisher(
            URLSession.shared.dataTaskPublisher(for: self.generateUrl(path: "/program", queryItems: queryItems))
                .tryMap { $0.data }
                .decode(type: [Program].self, decoder: JSONDecoder())
        )
    }

    func getEpisodes(from: Int, pageSize: Int, programId: String? = nil, search: String? = nil, tags: [String] = [], people: [String] = []) -> AnyPublisher<[Episode], Error> {

        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "from", value: "\(from)"),
            URLQueryItem(name: "pageSize", value: "\(pageSize)"),
        ]

        if programId != nil {
            queryItems.append(URLQueryItem(name: "programId", value: programId!))
        }

        if search?.isEmpty == false {
            queryItems.append(URLQueryItem(name: "search", value: search!))
        }

        for tag in tags {
            queryItems.append(URLQueryItem(name: "tag", value: tag))
        }

        for person in people {
            queryItems.append(URLQueryItem(name: "person", value: person))
        }


        return AnyPublisher(
            URLSession.shared.dataTaskPublisher(for: self.generateUrl(path: "/episode", queryItems: queryItems))
                .tryMap { $0.data }
                .decode(type: [Episode].self, decoder: JSONDecoder())
        )
    }

    func getPeople(from: Int, pageSize: Int, search: String? = nil, personType: PersonType? = nil) -> AnyPublisher<[Person], Error> {
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "from", value: "\(from)"),
            URLQueryItem(name: "pageSize", value: "\(pageSize)"),
        ]

        if search?.isEmpty == false {
            queryItems.append(URLQueryItem(name: "search", value: search!))
        }
        
        if personType != nil {
            queryItems.append(URLQueryItem(name: "search", value: "\(personType!)"))
        }

        return AnyPublisher(
            URLSession.shared.dataTaskPublisher(for: self.generateUrl(path: "/person", queryItems: queryItems))
                .tryMap { $0.data }
                .decode(type: [Person].self, decoder: JSONDecoder())
        )
    }
    
    func getRelatedPeople(personId: String) -> AnyPublisher<[Person], Error> {
        return AnyPublisher(
            URLSession.shared.dataTaskPublisher(for: self.generateUrl(path: "/person/\(personId)/related", queryItems: []))
                .tryMap { $0.data }
                .decode(type: [Person].self, decoder: JSONDecoder())
        )
    }
    
    func getRelatedEpisodes(episodeId: String) -> AnyPublisher<[Episode], Error> {
        return AnyPublisher(
            URLSession.shared.dataTaskPublisher(for: self.generateUrl(path: "/episode/\(episodeId)/related", queryItems: []))
                .tryMap { $0.data }
                .decode(type: [Episode].self, decoder: JSONDecoder())
        )
    }
}
