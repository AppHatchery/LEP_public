//
//  AppDelegate.swift
//  LEP
//
//  Created by Tanishk Deo on 5/26/22.
//

import UIKit
import Pendo
import FirebaseCore
import AVFoundation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var speechSynthesizer = AVSpeechSynthesizer()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        // Pre-warming the speech synthesizer
        let warmUpUtterance = AVSpeechUtterance(string: " ")
        warmUpUtterance.volume = 0 // Set volume to 0 so it's silent
        speechSynthesizer.speak(warmUpUtterance)

        FirebaseApp.configure()
        
        // Initialize TranslationManager to load translations
        _ = TranslationManager.shared
        
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
    
//    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
//        return UIInterfaceOrientationMask.landscape
//    }


}

