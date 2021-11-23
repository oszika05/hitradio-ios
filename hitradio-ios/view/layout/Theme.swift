//
//  Theme.swift
//  hitradio-ios
//
//  Created by Zsolt Oszlányi on 2021. 11. 22..
//

import Foundation
import SwiftUI

extension UIColor {
    convenience init(
        light lightModeColor: @escaping @autoclosure () -> UIColor,
        dark darkModeColor: @escaping @autoclosure () -> UIColor
    ) {
        self.init { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .light:
                return lightModeColor()
            case .dark:
                return darkModeColor()
            @unknown default:
                return lightModeColor()
            }
        }
    }
}

extension Color {
    init(
        light lightModeColor: @escaping @autoclosure () -> Color,
        dark darkModeColor: @escaping @autoclosure () -> Color
    ) {
        self.init(UIColor(
            light: UIColor(lightModeColor()),
            dark: UIColor(darkModeColor())
        ))
    }
    
    init(hex: Int) {
        self.init(
            red: Double((hex >> 16) & 0xFF) / 255.0,
            green: Double((hex >> 8) & 0xFF) / 255.0,
            blue: Double(hex & 0xFF) / 255.0,
            opacity: Double((hex >> 24) & 0xFF) / 255.0
        )
    }
    
    static var primaryColor: Self {
        Self(
            light: Color(hex: 0xFF007AFF),
            dark: Color(hex: 0xFF007AFF)
        )
    }
    
    static var primaryText: Self {
        Self(
            light: Color(hex: 0xFF202039),
            dark: Color(hex: 0xFF202039)
        )
    }
    
    static var secondaryText: Self {
        Self(
            light: Color(hex: 0xFF737373),
            dark: Color(hex: 0xFF737373)
        )
    }
    
    
    static var whiteColor: Self {
        Self(
            light: Color(hex: 0xFFFFFFFF),
            dark: Color(hex: 0xFFFFFFFF)
        )
    }
    
    static var greyColor: Self {
        Self(
            light: Color(hex: 0xFFF1F1F1),
            dark: Color(hex: 0xFFF1F1F1)
        )
    }
}
