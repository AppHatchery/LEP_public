//
//  UITextView+Extensions.swift
//  LEP
//
//  Created by Yago Arconada on 11/2/23.
//

import Foundation
import UIKit

extension UITextView {
    func calculateFontSize(minimumFont: CGFloat) -> CGFloat {
        let fontSize = font?.pointSize ?? minimumFont
        while fontSize > minimumFont {
            let size = sizeThatFits(CGSize(width: frame.size.width, height: frame.size.height))
            if size.height <= frame.size.height {
                return fontSize
            } else {
                return fontSize - 1
            }
        }
        return minimumFont
    }
    
    func adjustFontSize(minimumFont: CGFloat){
        font = UIFont(name: "GothamRounded-Bold", size: calculateFontSize(minimumFont: minimumFont))
    }
}
