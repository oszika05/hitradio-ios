//
//  SeekSlider.swift
//  hitradio-ios
//
//  Created by Zsolt Oszlányi on 2021. 10. 04..
//

import Foundation
import SwiftUI

struct SeekSlider: View {

    @EnvironmentObject private var audioController: AudioController

    
    var body: some View {
        if audioController.metadata?.isLive() == true {
            Text("live")
        }
        
        if audioController.metadata?.isLive() == false {
            Slider(value: $audioController.relativeSeekPosition, in: 0.0...1.0)
        }
    }


}
