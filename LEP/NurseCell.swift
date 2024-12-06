//
//  NurseCell.swift
//  LEP
//
//  Created by Tanishk Deo on 6/1/22.
//

import UIKit
import AVFoundation

class NurseCell: UICollectionViewCell, AVSpeechSynthesizerDelegate {
    
    let synthesizer = AVSpeechSynthesizer()
    
    
    @IBAction func speakerTapped(_ sender: UIButton) {
        let utterance = AVSpeechUtterance(string: "Estoy poniendo una vía intravenosa")
        utterance.voice = AVSpeechSynthesisVoice(language: "es-US")
        utterance.rate = 0.45
        synthesizer.delegate = self
        synthesizer.speak(utterance)
        self.layer.borderColor = UIColor.systemBlue.cgColor
        self.layer.borderWidth = 4
        
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        setupView()
    }
    
    func setupView() {
        
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 12
    }
    
    
    
    
}

