//
//  News.swift
//  hitradio-ios
//
//  Created by Zsolt Oszlányi on 2021. 10. 05..
//

import Foundation

class News: Codable, Equatable {
    let id: String;
    let title: String;
    let picture: String;
    let date: Date;
    let tags: [String];
    let content: String;

    init(
        id: String,
        title: String,
        picture: String,
        date: Date,
        tags: [String],
        content: String
    ) {
        self.id = id
        self.title = title
        self.picture = picture
        self.date = date
        self.tags = tags
        self.content = content
    }

    
    static func == (lhs: News, rhs: News) -> Bool {
        return lhs.id == rhs.id
    }
}
