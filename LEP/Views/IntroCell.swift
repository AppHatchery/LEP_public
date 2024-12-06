//
//  IntroCell.swift
//  LEP
//
//  Created by Yago Arconada on 6/27/22.
//

import UIKit

class IntroCell: UICollectionViewCell {
    
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var englishLabel: UILabel!
    
    func setupView(card: IntroCard) {
        image.image = UIImage(named: card.image)
        englishLabel.text = card.en
        
        configureView()
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
