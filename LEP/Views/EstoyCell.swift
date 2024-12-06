//
//  EstoyCell.swift
//  LEP
//
//  Created by Tanishk Deo on 6/13/22.
//

import UIKit

class EstoyCell: UICollectionViewCell {
    
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var spanishLabel: UILabel!
    @IBOutlet weak var englishLabel: UILabel!
    
    func setupView(card: PatientCard) {
        image.image = UIImage(named: card.image)
        spanishLabel.text = card.es
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
