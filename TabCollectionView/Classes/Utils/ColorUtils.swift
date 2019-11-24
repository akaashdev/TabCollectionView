//
//  ColorUtils.swift
//  ContactsApp
//
//  Created by Akaash Dev on 14/09/19.
//  Copyright © 2019 Akaash Dev. All rights reserved.
//

import UIKit

extension UIColor {
    class var adaptiveBackground: UIColor {
        if #available(iOS 13.0, *) {
            return .systemBackground
        } else {
            return .white
        }
    }
    
    class var adaptiveSeparator: UIColor {
        if #available(iOS 13.0, *) {
            return .separator
        } else {
            return UIColor(white: 0.8, alpha: 1)
        }
    }
    
    class var adaptiveOpaqueSeparator: UIColor {
        if #available(iOS 13.0, *) {
            return .opaqueSeparator
        } else {
            return UIColor(white: 0.8, alpha: 1)
        }
    }
    
    class var adaptiveLabel: UIColor {
        if #available(iOS 13.0, *) {
            return .label
        } else {
            return .black
        }
    }
    
    class var adaptiveSecondaryLabel: UIColor {
        if #available(iOS 13.0, *) {
            return .secondaryLabel
        } else {
            return .gray
        }
    }
    
    class var adaptiveTertiaryLabel: UIColor {
        if #available(iOS 13.0, *) {
            return .tertiaryLabel
        } else {
            return .lightGray
        }
    }
}

extension UIColor {

    convenience init(red: Float, green: Float, blue: Float) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(
            displayP3Red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: 1.0
        )
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: Float(red), green: Float(green), blue: Float(blue))
    }
    
    convenience init(hexValue: Int) {
        self.init(
            red: (hexValue >> 16) & 0xFF,
            green: (hexValue >> 8) & 0xFF,
            blue: hexValue & 0xFF
        )
    }
    
    func equals(_ rhs: UIColor) -> Bool {
        var lhsR: CGFloat = 0
        var lhsG: CGFloat  = 0
        var lhsB: CGFloat = 0
        var lhsA: CGFloat  = 0
        self.getRed(&lhsR, green: &lhsG, blue: &lhsB, alpha: &lhsA)
        
        var rhsR: CGFloat = 0
        var rhsG: CGFloat  = 0
        var rhsB: CGFloat = 0
        var rhsA: CGFloat  = 0
        rhs.getRed(&rhsR, green: &rhsG, blue: &rhsB, alpha: &rhsA)
        
        return  lhsR == rhsR &&
            lhsG == rhsG &&
            lhsB == rhsB &&
            lhsA == rhsA
    }
    
}

