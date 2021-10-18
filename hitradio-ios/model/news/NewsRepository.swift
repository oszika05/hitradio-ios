//
//  NewsRepository.swift
//  hitradio-ios
//
//  Created by Zsolt Oszlányi on 2021. 10. 05..
//

import Foundation
import Combine
import Alamofire

class NewsRepository {

    private let jsonDecoder = JSONDecoder()

    init() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        jsonDecoder.dateDecodingStrategy = .formatted(formatter)
    }

    private func generateUrl(path: String, queryItems: [URLQueryItem]) -> URL {
        var components = URLComponents()

        components.scheme = "https"
        components.host = "hitradio-mock.herokuapp.com"
        components.path = path
        components.queryItems = queryItems

        return components.url!
    }

    func getNews(from: Int, pageSize: Int, search: String? = nil, tags: [String] = []) -> AnyPublisher<Array<News>, Error> {
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "from", value: "\(from)"),
            URLQueryItem(name: "pageSize", value: "\(pageSize)"),
        ]

        if search != nil {
            queryItems.append(URLQueryItem(name: "search", value: search))
        }

        for tag in tags {
            queryItems.append(URLQueryItem(name: "tag", value: tag))
        }

        return AnyPublisher(
            URLSession.shared.dataTaskPublisher(for: self.generateUrl(path: "/news", queryItems: queryItems))
                .tryMap { $0.data }
                .mapError { $0 as Error }
                .decode(type: [News].self, decoder: jsonDecoder)
        )
    }

    func getRelatedNews(newsId: String) -> AnyPublisher<Array<News>, Error> {
        return AnyPublisher(
            URLSession.shared.dataTaskPublisher(for: self.generateUrl(path: "/news/\(newsId)/related", queryItems: []))
                .tryMap { $0.data }
                .decode(type: [News].self, decoder: jsonDecoder)
        )
    }
}
