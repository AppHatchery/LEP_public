//
//  VersionManager.swift
//  LEP
//
//  Created by Yago Arconada on 6/6/24.
//

import Foundation

class VersionManager {
    static let shared = VersionManager()
    
    private let versionKey = "appVersion"
    
    var isNewVersion: Bool {
        let currentVersion = 1
        let savedVersion = UserDefaults.standard.integer(forKey: versionKey)
        
        if currentVersion > savedVersion {
            UserDefaults.standard.set(currentVersion, forKey: versionKey)
            return true
        }
        return false
    }
}

