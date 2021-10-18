//
//  Person.swift
//  hitradio-ios
//
//  Created by Zsolt Oszlányi on 2021. 10. 12..
//

import Foundation


class Person: Codable {
    let id: String
    let name: String
    let type: PersonType
    let picture: String?
    let description: String?

    init(id: String, name: String, type: PersonType, picture: String? = nil, description: String? = nil) {
        self.id = id
        self.name = name
        self.type = type
        self.picture = picture
        self.description = description
    }
}

enum PersonType: Codable {
    case Host
    case Guest
}
