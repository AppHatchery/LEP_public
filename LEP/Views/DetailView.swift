//
//  DetailView.swift
//  LEP
//
//  Created by Tanishk Deo on 7/21/22.
//

import UIKit

class DetailView: UIView, PlaybackServiceDelegate {
   
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var englishLabel: UILabel!
    @IBOutlet weak var spanishLabel: UILabel!
    @IBOutlet weak var understandLabel: UILabel!
    @IBOutlet weak var speakerButton: UIButton!
    @IBOutlet weak var understandButton: UIButton!
    @IBOutlet weak var paddingView: UIView!
    
    let playback = PlaybackService()
    
    var spanishTitle: String?
    var englishTitle: String?
    var patientCard: PatientCard?
    var nurseCard: NurseCard?
    
    
    func setupView() {
//        self.dropShadow()
        closeButton.dropShadow()
        self.layer.cornerRadius = 8
        
        paddingView.layer.borderWidth = 2
        paddingView.layer.borderColor = UIColor.imageStrokeColor.cgColor
        paddingView.layer.cornerRadius = 16
        
        
        understandButton.layer.cornerRadius = 20
        understandButton.clipsToBounds = true
        understandButton.backgroundColor = UIColor.inactiveButtonColor
        understandButton.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8.0, bottom: 0, trailing: 8.0)
        
        if let card = patientCard {
            spanishTitle = card.es
            englishTitle = card.en
            imageView.image = UIImage(named: card.image)
            spanishLabel.text = spanishTitle
            englishLabel.text = englishTitle
        } else if let card = nurseCard {
            spanishTitle = card.es
            englishTitle = card.en
            imageView.image = UIImage(named: card.image)
            spanishLabel.text = spanishTitle
            englishLabel.text = englishTitle
        }
        

        
        playback.delegate = self
    }
    @IBAction func closeTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
            self.transform = CGAffineTransform( scaleX: 0.2, y: 0.2 )
        }) { _ in
            self.removeFromSuperview()
        }
    }
    
    
    @IBAction func audioTapped(_ sender: UIButton) {
        guard let spanishTitle = spanishTitle else {
            return
        }
        playback.content = spanishTitle
        
        if playback.isPlaying {
            speakerButton.setImage(UIImage(named: "speaker_default"), for: .normal)
            
            playback.stop()
        } else {
            speakerButton.setImage(UIImage(named: "speaker_mute"), for: .normal)
            playback.play()
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if((self.superview == nil)) {
            playback.stop()
        }
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
    
    
    func didFinishPlaying(_ service: PlaybackService?) {
        speakerButton.setImage(UIImage(named: "speaker_default"), for: .normal)
    }
    
    
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    

}
