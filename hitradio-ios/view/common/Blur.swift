//
//  Blur.swift
//  HitRadioBudapest
//
//  Created by Oszlányi Zsolt on 10/19/20.
//  Copyright © 2020 Oszlányi Zsolt. All rights reserved.
//

import SwiftUI

struct Blur: UIViewRepresentable {
    var style: UIBlurEffect.Style = .systemChromeMaterial
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
