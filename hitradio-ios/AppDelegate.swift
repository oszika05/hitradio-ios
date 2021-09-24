//
//  AppDelegate.swift
//  HitRadioBudapest
//
//  Created by Oszlányi Zsolt on 5/17/20.
//  Copyright © 2020 Oszlányi Zsolt. All rights reserved.
//

import UIKit
import AVFoundation

//@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("Appdelegate")
        
        let audioSession = AVAudioSession.sharedInstance()
            do {
                // Set the audio session category, mode, and options.
                try audioSession.setCategory(.playback, mode: .moviePlayback, options: [])
                
                application.beginReceivingRemoteControlEvents()
            } catch {
                print("Failed to set audio session category.")
            }
        
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}
