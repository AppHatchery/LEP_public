//
//  CardView.swift
//  LEP
//
//  Created by Yago Arconada on 9/29/23.
//

import UIKit

class CardView: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var englishLabel: UILabel!
    @IBOutlet weak var speakerIcon: UIButton!
    
    func setupView(card: NurseCard) {
        image.image = UIImage(named: card.image)
        englishLabel.text = card.en
        configureView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tagTapped))
        self.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
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
    
    @objc func tagTapped(){
//        print("fire!")
    }
}
