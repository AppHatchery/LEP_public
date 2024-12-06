//
//  IntroView.swift
//  LEP
//
//  Created by Tanishk Deo on 7/25/22.
//

import UIKit

class IntroView: UIView, PlaybackServiceDelegate {
    
    

    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var spanishTitleLabel: UILabel!
    @IBOutlet weak var englishTitleLabel: UILabel!
    @IBOutlet var spanishTitleSecondLabel: UILabel!
    @IBOutlet weak var englishTitleSecondLabel: UILabel!
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var understandButton: UIButton!
    @IBOutlet weak var understandLabel: UILabel!
    
    @IBOutlet weak var firstSpeaker: UIButton!
    @IBOutlet weak var secondSpeaker: UIButton!
    
    let playback = PlaybackService()
    
    var spanishTitle: String?
    var englishTitle: String?
    var card: IntroCard?

    let font = UIFont(name: "GothamRounded-Light", size: 22.0) ?? UIFont.systemFont(ofSize: 22)
    
    func setupView() {
        // Populate view with card content
        
        segmentControl.selectedSegmentIndex = 0
        
        segmentControl.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], for: .selected)
        
        
        spanishTitleSecondLabel.text = "Iré a ver cómo estás cada:"
        englishTitleSecondLabel.text = "I’ll come check on you every:"
        spanishTitle = card?.spanishSecondTitle
        englishTitle = card?.englishSecondTitle
        imageView.image = UIImage(named: card!.image)
        spanishTitleLabel.text = spanishTitle
        englishTitleLabel.text = englishTitle
        // Do any additional setup after loading the view.
        
        closeButton.dropShadow()
        self.layer.cornerRadius = 8
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.imageStrokeColor.cgColor
        imageView.layer.cornerRadius = 16
        
        understandButton.layer.cornerRadius = 20
        understandButton.clipsToBounds = true
        understandButton.backgroundColor = UIColor.inactiveButtonColor
        understandButton.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8.0, bottom: 0, trailing: 8.0)
        
        playback.delegate = self
    }
    
    @IBAction func understandTapped(_ sender: UIButton) {
        
        if understandButton.backgroundColor == UIColor.inactiveButtonColor {
            understandButton.backgroundColor = .patientGreenColor
            understandButton.setTitleColor(.white, for: .normal)
            understandLabel.isHidden = false
        } else {
            understandButton.backgroundColor = UIColor.inactiveButtonColor
            understandButton.setTitleColor(.black, for: .normal)
            understandLabel.isHidden = true
        }
        
    }
    
    @IBAction func audioTapped(_ sender: UIButton) {
        if sender.tag == 0 {
            spanishTitle = card?.spanishSecondTitle
            guard let spanishTitle = spanishTitle else {
                return
            }
            playback.content = spanishTitle
            
            if playback.isPlaying {
                stopAudio(button: sender)
            } else {
                playAudio(button: sender)
            }
        } else {
            // Add nurse selection to the introduction of time
            if segmentControl.selectedSegmentIndex == 0 {
                spanishTitle = "Iré a ver cómo estás cada vez que sea necesario"
            } else {
                let timeSelected: String = segmentControl.titleForSegment(at: segmentControl.selectedSegmentIndex) ?? "hora"
                spanishTitle = "Iré a ver cómo estás cada \(timeSelected))"
            }
            guard let spanishTitle = spanishTitle else {
                return
            }
            playback.content = spanishTitle
            
            if playback.isPlaying {
                stopAudio(button: sender)
            } else {
                playAudio(button: sender)
            }
        }
        
    }
    
    private func playAudio(button: UIButton) {
        button.setImage(UIImage(named: "speaker_mute"), for: .normal)
        playback.play()
        
    }
    
    private func stopAudio(button: UIButton) {
        button.setImage(UIImage(named: "speaker_default"), for: .normal)
        
        playback.stop()
    }
    
    
    func didFinishPlaying(_ service: PlaybackService?) {
        stopAudio(button: firstSpeaker)
        stopAudio(button: secondSpeaker)
    }
    
    
    @IBAction func close(_ sender: UIButton) {
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
            self.transform = CGAffineTransform( scaleX: 0.2, y: 0.2 )
        }) { _ in
            self.removeFromSuperview()
        }
    }
    

}
