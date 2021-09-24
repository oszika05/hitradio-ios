//
//  Song.swift
//  HitRadioBudapest
//
//  Created by Oszlányi Zsolt on 5/17/20.
//  Copyright © 2020 Oszlányi Zsolt. All rights reserved.
//

import Foundation

class Song: Codable {
    let id: Int
    let title: String
    let artist: String
    let jazlerId: String
    let length: String
    
    init(id: Int, title: String, artist: String, jazlerId: String, length: String) {
        self.id = id
        self.title = title
        self.artist = artist
        self.jazlerId = jazlerId
        self.length = length
    }
}
