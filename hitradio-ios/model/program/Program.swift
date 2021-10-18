//
//  Program.swift
//  hitradio-ios
//
//  Created by Zsolt Oszlányi on 2021. 10. 12..
//

import Foundation

class Program: Codable {
    let id: String
    let name: String
    let picture: String
    let description: String?

    init(id: String, name: String, picture: String, description: String? = nil) {
        self.id = id
        self.name = name
        self.picture = picture
        self.description = description
    }
}
