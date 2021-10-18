//
//  Episode.swift
//  hitradio-ios
//
//  Created by Zsolt Oszlányi on 2021. 10. 12..
//

import Foundation

class Episode: Codable {
    let id: String
    let title: String
    let date: Date
    let description: String?
    let tags: [String]
    let program: Program

    let audioUrl: String

    let hosts: [Person]
    let guests: [Person]

    init(
        id: String,
        title: String,
        date: Date,
        description: String?,
        tags: [String],
        program: Program,
        audioUrl: String,
        hosts: [Person],
        guests: [Person]
    ) {
        self.id = id
        self.title = title
        self.date = date
        self.description = description
        self.tags = tags
        self.program = program
        self.audioUrl = audioUrl
        self.hosts = hosts
        self.guests = guests
    }
}
