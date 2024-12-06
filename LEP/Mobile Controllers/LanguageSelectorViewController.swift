//
//  LanguageSelectorViewController.swift
//  LEP
//
//  Created by Yago Arconada on 10/22/23.
//

import UIKit

class LanguageSelectorViewController: UIViewController {
    
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var languageDirection: UIImageView!
    @IBOutlet weak var languageDirectionLabel: UILabel!
    
    var selectedLanguage = Model().speechLanguages[0]
    var inputLanguage = Model().translateLanguages[0]
    var targetLanguage = LanguageManager.shared.currentLanguageCode
    var currentLanguageSelected = "English"
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        languageDirectionLabel.text = "Please select input language:\n\n\(Model().availableLanguages[0])"
        buttons[1].setTitle(LanguageManager.shared.currentLanguageName, for: .normal)
        targetLanguage = LanguageManager.shared.currentLanguageCode
        buttons[0].layer.cornerRadius = 24
        buttons[1].layer.cornerRadius = 24
        buttons[0].titleLabel?.font = UIFont.gothamRoundMedium16
        buttons[1].titleLabel?.font = UIFont.gothamRoundMedium16
        
        NotificationCenter.default.addObserver(self, selector: #selector(languageChanged), name: .languageDidChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func languageChanged(notification: Notification) {
        // Update UI elements or data that depend on the current language
        print("language should have changed")
        buttons[1].setTitle(LanguageManager.shared.currentLanguageName, for: .normal)
        // If target translation language is selected then change all the parameters
        if buttons[1].backgroundColor == UIColor.nurseBlueColor {
            targetLanguage = "en"
            selectedLanguage = LanguageManager.shared.currentLocale
            inputLanguage = LanguageManager.shared.currentLanguageCode
            currentLanguageSelected = LanguageManager.shared.currentLanguageName
        } else {
            targetLanguage = LanguageManager.shared.currentLanguageCode
            selectedLanguage = "en-US" // LanguageManager.shared.currentLocale
            inputLanguage = "en"
            currentLanguageSelected = "English"
        }
        languageDirectionLabel.text = "Please select input language:\n\n\(currentLanguageSelected)"
    }
    
    @IBAction func selectLanguage(_ sender: UIButton){
        switch sender.tag {
        case 0:
            buttons[0].backgroundColor = UIColor.nurseBlueColor
            buttons[0].setTitleColor(UIColor.white, for: .normal)
            buttons[1].backgroundColor = UIColor.inactiveButtonColor
            buttons[1].setTitleColor(UIColor.darkGray, for: .normal)
            targetLanguage = LanguageManager.shared.currentLanguageCode
            selectedLanguage = "en-US"
            inputLanguage = "en"
            currentLanguageSelected = "English"
            languageDirection.image = UIImage(systemName: "arrow.right")
        case 1:
            buttons[1].backgroundColor = UIColor.nurseBlueColor
            buttons[1].setTitleColor(UIColor.white, for: .normal)
            buttons[0].backgroundColor = UIColor.inactiveButtonColor
            buttons[0].setTitleColor(UIColor.darkGray, for: .normal)
            targetLanguage = "en"
            selectedLanguage = LanguageManager.shared.currentLocale
            inputLanguage = LanguageManager.shared.currentLanguageCode
            currentLanguageSelected = LanguageManager.shared.currentLanguageName
            languageDirection.image = UIImage(systemName: "arrow.left")
        default:
            print("none of the tags were valid")
        }
        
        languageDirectionLabel.text = "Please select input language:\n\n\(currentLanguageSelected)"
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? TranslateViewController {
            vc.selectedLanguage = selectedLanguage
            vc.inputLanguage = inputLanguage
            vc.targetLanguage = targetLanguage
        }
    }

}
