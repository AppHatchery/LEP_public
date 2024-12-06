//
//  UnitManager.swift
//  LEP
//
//  Created by Yago Arconada on 4/26/24.
//

import Foundation

class UnitManager {
    static let shared = UnitManager()

    let unitsAvailable : [String: (shortName: String, frequentCards: [Drawer], nursingTasks: [[NurseCard]])] = [
        "All Units": (shortName: "All Units", Units().general_phrases, Units().general_tasks),
        "Sibley General": (shortName: "Sibley", Units().sibley_phrases, Units().sibley_tasks),
        "Sibley Front Desk": (shortName: "Sibley Front Desk", Units().sibley_front_desk_phrases, Units().sibley_tasks),
        "Sibley Medical Assistants": (shortName: "Sibley Medical Assistants", Units().sibley_medical_assistant_phrases, Units().sibley_tasks),
        "Sibley Sonography": (shortName: "Sibley Sonography", Units().sibley_sonographer_phrases, Units().sibley_tasks),
//        "Day Surgery": (shortName: "Day Surgery", Units().day_surgery_phrases, Units().day_surgery_tasks),
//        "Rehab PT/OT/Speech": (shortName: "Rehab PT/OT/Speech", Units().therapist_phrases, Units().therapist_tasks),
//        "PICU": (shortName: "PICU", Units().general_phrases, Units().general_tasks),
//        "4th South": (shortName: "4th South", Units().general_phrases, Units().general_tasks),
//        "TICU": (shortName: "TICU", Units().general_phrases, Units().general_tasks),
//        "CICU": (shortName: "CICU", Units().general_phrases, Units().general_tasks),
//        "ER": (shortName: "ER", Units().general_phrases, Units().general_tasks),
//        "Neuro": (shortName: "Neuro", Units().general_phrases, Units().general_tasks),
//        "Pulmonology": (shortName: "Pulmonology", Units().general_phrases, Units().general_tasks),
//        "GI": (shortName: "GI", Units().general_phrases, Units().general_tasks),
//        "Nephrology": (shortName: "Nephrology", Units().general_phrases, Units().general_tasks),
//        "Endocrinology": (shortName: "Endocrinology", Units().general_phrases, Units().general_tasks),
//        "NICU": (shortName: "NICU", Units().general_phrases, Units().general_tasks),
//        "Orthopedics": (shortName: "Orthopedics", Units().general_phrases, Units().general_tasks),
//        "Urology": (shortName: "Urology", Units().general_phrases, Units().general_tasks),
//        "Transplant Stepdown": (shortName: "Transplant Stepdown", Units().general_phrases, Units().general_tasks),
//        "CSO": (shortName: "CSO", Units().general_phrases, Units().general_tasks),
//        "PCA": (shortName: "PCA", Units().general_phrases, Units().general_tasks),
//        "5WE": (shortName: "5WE", Units().general_phrases, Units().general_tasks),
//        "Aflac": (shortName: "Aflac", Units().general_phrases, Units().general_tasks),
    ]

    // Holds the Phrases and Tasks, typically general
    var currentUnit: String = "4th South"
    
    var currentUnitPhrases: [Drawer] {
        return unitsAvailable.first { $0.value.shortName
            == currentUnit }?.value.frequentCards ?? Units().general_phrases
    }
    var currentUnitTasks: [[NurseCard]] {
        return unitsAvailable.first { $0.value.shortName
            == currentUnit }?.value.nursingTasks ?? Units().general_tasks
    }
    
    func setCurrentUnit(to newUnit: String) {
        currentUnit = newUnit
        NotificationCenter.default.post(name: .unitDidChange, object: nil)
    }
}

extension Notification.Name {
    static let unitDidChange = Notification.Name("UnitDidChange")
}
