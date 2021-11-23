//
//  Image.swift
//  hitradio-ios
//
//  Created by Zsolt Oszlányi on 2021. 11. 22..
//

import Foundation
import SwiftUI

extension Image {
    func centerCropped() -> some View {
        GeometryReader { geo in
            self
            .resizable()
            .scaledToFill()
            .frame(width: geo.size.width, height: geo.size.height)
            .clipped()
        }
    }
}
