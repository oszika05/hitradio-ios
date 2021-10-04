//
//  NetworkObserver.swift
//  hitradio-ios
//
//  Created by Zsolt Oszlányi on 2021. 10. 04..
//

import Foundation
import Reachability

typealias NetworkChangeObserver = (_: StreamQuality) -> Void

class NetworkObserver {

    private var connection: Reachability.Connection? = nil
    private var reachability: Reachability? = nil

    private var observer: NetworkChangeObserver? = nil

    init() {
        do {
            self.reachability = try Reachability()
        } catch {
            print("Unable to create notifier")
        }

        self.reachability?.whenReachable = { reachability in
            self.connection = reachability.connection

            let quality = self.connection == Reachability.Connection.wifi ? StreamQuality.High : StreamQuality.Low
            
            self.observer?(quality)

//            if self.source != nil {
//
//                self.player.changeSource(url: self.source!.url.get(quality: quality))
//            }

        }
        self.reachability?.whenUnreachable = { _ in
            self.connection = nil
        }

        do {
            try self.reachability?.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }

    func observe(_ observer: @escaping NetworkChangeObserver) {
        self.observer = observer
    }

    func removeObserver() {
        self.observer = nil
    }
    
    var currentQuality: StreamQuality {
        return self.connection == Reachability.Connection.wifi ? StreamQuality.High : StreamQuality.Low
    }

    deinit {
        self.reachability?.stopNotifier()
    }
}
