//
//  QuestionsView.swift
//  LEP
//
//  Created by Tanishk Deo on 7/22/22.
//

import UIKit
import Pendo

class QuestionsView: UIView, PlaybackServiceDelegate{

    
    
    @IBOutlet var buttonCollection : [UIButton]!
    @IBOutlet weak var closeButton: UIButton!
    
    let playback = PlaybackService()
    
    var selectedButton: UIButton?
    
    

    
    func didFinishPlaying(_ service: PlaybackService?) {
        
        playback.content = nil
        selectedButton?.layer.borderWidth = 0
        selectedButton?.layer.borderColor = nil
        
        if let selectedButton = selectedButton, let speakerButton = selectedButton.subviews.first(where: {$0 as? UIButton != nil}) as? UIButton {
            speakerButton.setImage(UIImage(named: "speaker_default"), for: .normal)
            speakerButton.tintColor = .black
        }
        
    }
    
    
    
    @objc func buttonAction(sender: UIButton!) {
        if !playback.isPlaying{
            if let parent = sender.superview as? UIButton, let text = parent.titleLabel?.text?.dropFirst().dropLast() {
                print("clicked on first time")
                selectedButton = parent
                playback.content = String(text)
                playback.play()
                
                parent.layer.borderWidth = 3.0
                parent.layer.borderColor =  UIColor.patientGreenColor.cgColor
                sender.setImage(UIImage(named: "speaker_mute"), for: .normal)
                sender.tintColor = .black
                PendoManager.shared().track("Questions speaker", properties: ["question": text,"state":"play"])
            }
        } else if let parent = sender.superview as? UIButton, selectedButton == parent, playback.isPlaying {
            playback.stop()
            PendoManager.shared().track("Questions speaker", properties: ["question": parent.titleLabel ?? "None","state":"mute"])
            
        } else if playback.isPlaying {
            playback.stop()
        
        }

     }

    
    
    
    
    
    
    
    @IBAction func closeTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
            self.transform = CGAffineTransform( scaleX: 0.2, y: 0.2 )
        }) { _ in
            self.removeFromSuperview()
        }
    }
    
    
    func setupView() {
        
        playback.delegate = self
        
        
        for button in buttonCollection {
            let speaker = UIButton(frame: CGRect(x: 16, y: (button.frame.height/2.0) - 12, width: 24.0, height: 24.0))
            speaker.setImage(UIImage(named: "speaker_default"), for: .normal)
            speaker.tintColor = .black
            speaker.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            button.layer.cornerRadius = 30
            button.addSubview(speaker)
            button.bringSubviewToFront(speaker)
            button.dropShadow()
        }
        closeButton.dropShadow()
        self.layer.cornerRadius = 8
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
            if let vc = parentViewController as? PatientController {
                vc.showDrawer()
            } else if let vc = parentViewController as? NurseController {
                vc.showDrawer()
            }
            // Change speaker icon to white
        }
    }
}
