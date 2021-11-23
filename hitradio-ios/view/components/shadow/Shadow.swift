//
//  Shadow.swift
//  hitradio-ios
//
//  Created by Zsolt Oszlányi on 2021. 11. 22..
//

import Foundation
import SwiftUI


struct BoxShadow: ViewModifier {
    
    var enabled: Bool = true
    
    func body(content: Content) -> some View {
        if !enabled {
            content
        } else {
            content
                .shadow(color: Color(hex: 0x1A000000), radius: 42.0, x: 0.0, y: 17.0)
        }
    }
}

struct NowplayingShadow: ViewModifier {
    
    var enabled: Bool = true
    
    func body(content: Content) -> some View {
        if !enabled {
            content
        } else {
            content
                .shadow(color: Color(hex: 0x1A000000), radius: 42.0, x: 0.0, y: -4.0)
        }
    }
}

extension View {
    func boxShadow(enabled: Bool = true) -> some View {
        modifier(BoxShadow(enabled: enabled))
    }
    
    func nowplayingShadow(enabled: Bool = true) -> some View {
        modifier(NowplayingShadow(enabled: enabled))
    }
}
