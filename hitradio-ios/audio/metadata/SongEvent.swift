//
//  SongEvent.swift
//  HitRadioBudapest
//
//  Created by Oszlányi Zsolt on 5/17/20.
//  Copyright © 2020 Oszlányi Zsolt. All rights reserved.
//

import Foundation

class SongEvent: Codable {
    let id: Int
    let song: Song
    let start: Date
    let end: Date
    
    init(id: Int, song: Song, time: DateInterval) {
        self.id = id
        self.song = song
        self.start = time.start
        self.end = time.end
    }
    
    init(id: Int, song: Song, start: Date, end: Date) {
        self.id = id
        self.song = song
        self.start = start
        self.end = end
    }
    
    func getInterval() -> DateInterval {
        return DateInterval(start: self.start, end: self.end)
    }
    
    enum CodingKeys : String, CodingKey {
          case id
          case song
          case start = "startTime"
          case end = "endTime"
    }
}
