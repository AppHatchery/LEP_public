//
//  DetailController.swift
//  LEP
//
//  Created by Tanishk Deo on 5/27/22.
//

import UIKit
import AVFoundation

class DetailController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func audioTapped(_ sender: UIButton) {
        let utterance = AVSpeechUtterance(string: "Estoy poniendo una vía intravenosa")
        utterance.voice = AVSpeechSynthesisVoice(language: "es-US")
        utterance.rate = 0.45
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
        
    }
    
    @IBAction func close(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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
