//
//  UIView+Extensions.swift
//  LEP
//
//  Created by Yago Arconada on 7/13/22.
//

import UIKit

extension UIView {

    func dropShadow() {
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 2.0
//        layer.shadowColor = color
//        layer.cornerRadius = 2
//        layer.masksToBounds = false
//        layer.shadowColor = UIColor.black.cgColor
//        layer.shadowOpacity = 0.5
//        layer.shadowOffset = CGSize(width: 1, height: 1)
//        layer.shadowRadius = 2
//        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
//        layer.shouldRasterize = true
//        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
}


extension UIResponder {
    public var parentViewController: UIViewController? {
        return next as? UIViewController ?? next?.parentViewController
    }
}
