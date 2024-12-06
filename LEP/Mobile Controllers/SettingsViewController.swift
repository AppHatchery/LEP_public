//
//  SettingsViewController.swift
//  LEP
//
//  Created by Yago Arconada on 4/5/24.
//

import UIKit
import Pendo

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var roleButton: UIButton!
    @IBOutlet weak var unitButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureRoleMenu()
        configureUnitMenu()
        
        roleButton.layer.cornerRadius = 12
        unitButton.layer.cornerRadius = 12
        saveButton.layer.cornerRadius = 20        
    }
    
    private func configureUnitMenu() {
        var actions: [UIAction] = []

        // Sort the unitsAvailable by key in alphabetical order
        let sortedUnits = UnitManager.shared.unitsAvailable.sorted { $0.key < $1.key }

        for unit in sortedUnits {
            let isSelected = unit.key == UnitManager.shared.currentUnit
            let unitAction = UIAction(title: unit.key, state: isSelected ? .on : .off) { _ in
                // Accessing the singleton instance to set the current unit
                UnitManager.shared.setCurrentUnit(to: unit.key)
            }
            actions.append(unitAction)
        }

        let menu = UIMenu(title: "Choose Your Unit", children: actions)
        unitButton.menu = menu
        unitButton.showsMenuAsPrimaryAction = true
        view.addSubview(unitButton)
        unitButton.dropShadow()
    }
    
    private func configureRoleMenu() {
        var actions: [UIAction] = []
        
        // Sort the unitsAvailable by key in alphabetical order
        let sortedRoles = RoleManager.shared.rolesAvailable.sorted { $0.key < $1.key }

        for role in sortedRoles {
            let isSelected = role.key == RoleManager.shared.currentRole
            let roleAction = UIAction(title: role.key, state: isSelected ? .on : .off) { _ in
                // Accessing the singleton instance to set the current unit
                RoleManager.shared.setCurrentRole(to: role.key)
                FrequentCardsViewController.roleSelected = RoleManager.shared.currentRole
            }
            actions.append(roleAction)
        }

        let menu = UIMenu(title: "Choose Your Role", children: actions)

        roleButton.menu = menu
        roleButton.showsMenuAsPrimaryAction = true
        view.addSubview(roleButton)
        roleButton.dropShadow()
    }
    
    @IBAction func saveSettings(_ sender: UIButton){
        /*
        // For Testing
        UnitManager.shared.setCurrentUnit(to: "All")
        RoleManager.shared.setCurrentRole(to: "All")
        FrequentCardsViewController.roleSelected = RoleManager.shared.currentRole
        self.dismiss(animated: true, completion: nil)
        */
        
        
        // Check user has filled in details
        if FrequentCardsViewController.roleSelected == "" {
            let addARole = UIAlertController(title: "Please specify a role before continuing", message: "", preferredStyle: .alert)
            addARole.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(addARole, animated: true,completion: nil)
        } else {
            let confirmCustomization = UIAlertController(title: "Do you want to customize the app for the following unit and role?", message: "\n\(UnitManager.shared.currentUnit) \n\n \(RoleManager.shared.currentRole)", preferredStyle: .alert)
                            
            // If user confirms, set up everything based on the selected role
            confirmCustomization.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                
                self.connectPendo()
                self.dismiss(animated: true, completion: nil)
            }))
            
            // If user cancels, present the role selection dialog again
            confirmCustomization.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            self.present(confirmCustomization, animated: true, completion: nil)
        }
        
    }
    
    func connectPendo(){
        // Setting up Pendo
        // Set up Pendo
        let appKey = "YOUR-PENDO-ID"
        PendoManager.shared().setup(appKey)
        
        // Set up Pendo
        // TODO: Add firebase installation
        // Set visitor as "" to anonymize the entries
        let visitorId = RoleManager.shared.currentRole + "-" + UnitManager.shared.currentUnit + "-" + UUID().uuidString

        #if CHOAPRODUCTION
        print("CHOA Production")
        let accountId = "April-16-Trial-v1"
        #elseif DEBUG
        print("debug")
        let accountId = "LEP-Testing"
        #else
        print("else")
        let accountId = "Sibley-Testing" // change for testing releases
        #endif
        
//        PendoManager.shared().startSession(
//            visitorId,
//            accountId: accountId,
//            visitorData: [:],
//            accountData: [:]
//        )
    }
}
