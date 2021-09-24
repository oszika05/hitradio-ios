//
//  HTMLView.swift
//  HitRadioBudapest
//
//  Created by Zsolt Oszlányi on 2020. 11. 19..
//  Copyright © 2020. Oszlányi Zsolt. All rights reserved.
//

import WebKit
import SwiftUI

struct HTMLView: UIViewRepresentable {
    let content: String
    
    init(_ content: String) {
        self.content = content
    }

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(content, baseURL: nil)
    }
}
