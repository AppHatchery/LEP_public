//
//  CardTag.swift
//  LEP
//
//  Created by Yago Arconada on 9/29/23.
//

import UIKit

class CardTag: UICollectionViewCell {
    @IBOutlet weak var contentButton: UILabel!
    @IBOutlet weak var contentBackground: UIView!
    
    func setupView(){
        contentBackground.layer.backgroundColor = UIColor.inactiveButtonColor.cgColor
        contentBackground.layer.cornerRadius = 16
        contentButton.textColor = UIColor.darkGray
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tagTapped))
        contentBackground.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
    }
    
    @objc func tagTapped(){
//        print("fire!")
    }
    
    override var isSelected: Bool {
        willSet {
            super.isSelected = newValue
            if newValue {
                    contentBackground.layer.backgroundColor = UIColor.nurseBlueColor.cgColor
                    contentButton.textColor = UIColor.white
            } else {
                contentBackground.layer.backgroundColor = UIColor.inactiveButtonColor.cgColor
                contentButton.textColor = UIColor.darkGray
            }
        }
    }
}
