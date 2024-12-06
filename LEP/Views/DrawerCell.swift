//
//  DrawerView.swift
//  LEP
//
//  Created by Yago Arconada on 6/23/22.
//

import UIKit

class DrawerCell : UICollectionViewCell {
    
    @IBOutlet weak var contentButton: UILabel!
    
    func setupView(){
        contentButton.dropShadow()
        contentButton.layer.backgroundColor = UIColor.inactiveButtonColor.cgColor
        contentButton.layer.cornerRadius = 30
        contentButton.textColor = UIColor.black
//        self.layoutMargins = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 30)
    }
    
    
    func cellTapped(){
        print("fire!")
        if contentButton.layer.backgroundColor == UIColor.inactiveButtonColor.cgColor {
            contentButton.layer.backgroundColor = UIColor.nurseBlueColor.cgColor
            contentButton.textColor = UIColor.white
        } else {
            contentButton.layer.backgroundColor = UIColor.inactiveButtonColor.cgColor
            contentButton.textColor = UIColor.black
        }
    }
    
}
