//
//  NurseCell.swift
//  LEP
//
//  Created by Tanishk Deo on 6/1/22.
//

import UIKit
import Pendo

class NurseCell: UICollectionViewCell, PlaybackServiceDelegate{
    
    let playback = PlaybackService()
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var englishLabel: UILabel!
    @IBOutlet weak var speakerIcon: UIButton!
    
    @objc func speakerTapped() {
        playback.play()
        
        self.layer.borderColor = UIColor.nurseBlueColor.cgColor
        self.layer.borderWidth = 4
        PendoManager.shared().track("Nurse Task Speaker", properties: ["task":englishLabel.text ?? "None"])
    }
    
    // Detection of finish playing is not working so configureView never triggers
    func didFinishPlaying(_ service: PlaybackService?) {
        playback.stop()
        configureView()
    }
    
    func setupView(card: NurseCard) {
        playback.delegate = self
        image.image = UIImage(named: card.image)
        englishLabel.text = card.en
        playback.content = card.es
        configureView()
        speakerIcon.addTarget(self, action: #selector(speakerTapped), for: .touchUpInside)
    }


    func configureView() {
        backgroundColor = .clear
        layer.masksToBounds = false
        layer.shadowOpacity = 0.23
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowColor = UIColor.black.cgColor
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
    }
}

