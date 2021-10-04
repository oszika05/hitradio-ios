//
//  SeekPositionManager.swift
//  hitradio-ios
//
//  Created by Zsolt Oszlányi on 2021. 10. 04..
//

import Foundation
import Combine

class SeekPositionManager: ObservableObject {
    
    private let player: AudioPlayer
    
    @Published private(set) var positionInSeconds: Double = 0.0
    @Published private(set) var durationInSeconds: Double = 0.0
    
    @Published private var _relativePosition: Double = 0.0
    
    var relativePosition: Double {
        set(newValue) {
            let posInSeconds = newValue * self.durationInSeconds
            
            print("newValue: \(newValue), posInSeconds: \(newValue * self.durationInSeconds), duration: \(self.durationInSeconds)")
            
            self.player.seekTo(position: posInSeconds)
        }
        
        get {
            return _relativePosition
        }
    }
    
    private var cancellables: Set<AnyCancellable> = Set()
    
    
    
    init(player: AudioPlayer) {
        self.player = player
    }
    
    func start() {
        let timer = Timer.publish(every: 1.0/60, on: .main, in: .default)
            .autoconnect()
            .receive(on: RunLoop.main)
            .share()
        
        timer
            .map { _ in self.player.getCurrentProgress() }
            .removeDuplicates()
            .sink { progress in
                self.positionInSeconds = progress
            }
            .store(in: &self.cancellables)
        
        timer
            .map { _ in self.player.getCurrentDuration() }
            .removeDuplicates()
            .sink { duration in
                self.durationInSeconds = duration
            }
            .store(in: &self.cancellables)
        
        timer
            .map { _ in
                if self.player.getCurrentDuration() < 0.01 {
                    return 0.0
                }
                
                return self.player.getCurrentProgress() / self.player.getCurrentDuration()
            }
            .removeDuplicates()
            .sink { relativePosition in
                self._relativePosition = relativePosition
            }
            .store(in: &self.cancellables)
        
    }
    
    func stop() {
        cancellables.forEach { cancellable in
            cancellable.cancel()
        }
    }
    
    
    
}
