//
//  RoleManager.swift
//  LEP
//
//  Created by Yago Arconada on 4/26/24.
//

import Foundation

class RoleManager {
    static let shared = RoleManager()

    let rolesAvailable : [String: (shortName: String, frequentCards: [Drawer], nursingTasks: [[NurseCard]])] = [
        "All Roles": (shortName: "All", Roles().general_phrases, Roles().general_tasks),
        "Physician": (shortName: "MD", Roles().general_phrases, Roles().general_tasks),
        "Advanced Practice Provider": (shortName: "APP", Roles().general_phrases, Roles().general_tasks),
        "Nurse": (shortName: "Nurse", Roles().general_phrases, Roles().general_tasks),
        "Physical Therapist": (shortName: "PT", Roles().general_phrases, Roles().general_tasks),
        "Occupational Therapist": (shortName: "OT", Roles().general_phrases, Roles().general_tasks),
        "Speech Therapist": (shortName: "Speech", Roles().general_phrases, Roles().general_tasks),
        "Audiologist": (shortName: "Audiologist", Roles().general_phrases, Roles().general_tasks),
        "Patient Care Technicians": (shortName: "PCT", Roles().general_phrases, Roles().general_tasks),
        "Front Desk": (shortName: "Front Desk", Roles().general_phrases, Roles().general_tasks),
        "Patient Sitter": (shortName: "Sitters", Roles().general_phrases, Roles().general_tasks),
        "Respiratory Therapist": (shortName: "RT", Roles().general_phrases, Roles().general_tasks),
        "Nutritionist": (shortName: "Nutritionist", Roles().general_phrases, Roles().general_tasks),
        "Family Experience": (shortName: "Family Experience", Roles().general_phrases, Roles().general_tasks),
        // Sibley
//        "Sonographer": (shortName: "Sonographer", Roles().general_phrases, Roles().general_tasks),
//        "Medical Assistant": (shortName: "MA", Roles().general_phrases, Roles().general_tasks),
    ]

    // Holds the Phrases and Tasks, typically general
    var currentRole: String = "Advanced Practice Provider"
    
    var currentRolePhrases: [Drawer] {
        return rolesAvailable.first { $0.key
            == currentRole }?.value.frequentCards ?? Roles().general_phrases
    }
    var currentRoleTasks: [[NurseCard]] {
        return rolesAvailable.first { $0.key
            == currentRole }?.value.nursingTasks ?? Roles().general_tasks
    }
    
    var currentRoleShortName: String {
        return rolesAvailable.first { $0.key
            == currentRole }?.value.shortName ?? "All"
    }
    
    func setCurrentRole(to newRole: String) {
        currentRole = newRole
        NotificationCenter.default.post(name: .roleDidChange, object: nil)
    }
}

extension Notification.Name {
    static let roleDidChange = Notification.Name("RoleDidChange")
}
