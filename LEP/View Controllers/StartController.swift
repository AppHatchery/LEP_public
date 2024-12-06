//
//  StartController.swift
//  LEP
//
//  Created by Tanishk Deo on 1/13/23.
//

import UIKit

class StartController: UIViewController {
    
    @IBOutlet weak var PICUButton: UIButton!
    @IBOutlet weak var DaySurgeryButton: UIButton!
    @IBOutlet weak var GeneralButton: UIButton!
    
    var tempfloor = 0
    static var floor = 0

//    override func viewWillAppear(_ animated: Bool) {
//
//        DispatchQueue.main.async {
//            self.performSegue(withIdentifier: "Start", sender: nil)
//        }
//    }
    
    override func viewDidLoad() {
//        PICUButton.dropShadow()
//        DaySurgeryButton.dropShadow()
//        GeneralButton.dropShadow()
    }
    
    func selectedState(button: UIButton, state: Bool){
        //
        if state {
            button.layer.borderWidth = 4
            button.layer.borderColor = UIColor.nurseBlueColor.cgColor
            button.layer.cornerRadius = 8
        } else {
            button.layer.borderWidth = 0
        }
    }
    
    @IBAction func selection(_ sender: UIButton){
        // Unselect other buttons
        switch sender.tag {
        case 0:
            // load PICU
            selectedState(button: PICUButton, state: true)
            selectedState(button: DaySurgeryButton, state: false)
            selectedState(button: GeneralButton, state: false)
            tempfloor = 0

            print("Load PICU")
        case 1:
            // load Surgery
            selectedState(button: PICUButton, state: false)
            selectedState(button: DaySurgeryButton, state: true)
            selectedState(button: GeneralButton, state: false)
            tempfloor = 1

            print("Load surgery")
        case 2:
            // load General
            selectedState(button: PICUButton, state: false)
            selectedState(button: DaySurgeryButton, state: false)
            selectedState(button: GeneralButton, state: true)
            tempfloor = 2

            print("Load default")
        default:
            // Default
            print("Load default")
        }
    }
    
    @IBAction func goNext(_ sender: UIButton){
        // Load settings for that floor
        StartController.floor = tempfloor
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "Start", sender: nil)
        }
    }
    
    
    // Add logic for assigning cards to a specific floor
}



