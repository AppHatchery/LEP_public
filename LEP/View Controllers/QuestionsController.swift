//
//  QuestionsController.swift
//  LEP
//
//  Created by Tanishk Deo on 6/2/22.
//

import UIKit

class QuestionsController: UIViewController {
    
    @IBOutlet var buttonCollection : [UIButton]!


    override func viewDidLoad() {
        super.viewDidLoad()

        for button in buttonCollection {
            button.layer.cornerRadius = 30
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func tapToHighlight(_ sender: UIButton){
        if sender.backgroundColor == UIColor.patientGreenColor {
            sender.backgroundColor = UIColor.inactiveButtonColor
            sender.setTitleColor(UIColor.black, for: .normal)
            sender.tintColor = .black
            // Change speaker icon to black
        } else {
            sender.backgroundColor = UIColor.patientGreenColor
            sender.setTitleColor(UIColor.white, for: .normal)
            sender.tintColor = .white
            // Change speaker icon to white
        }
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
