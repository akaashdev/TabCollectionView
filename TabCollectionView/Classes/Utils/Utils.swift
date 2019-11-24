//
//  Utils.swift
//  TabCollectionView
//
//  Created by Akaash Dev on 18/11/19.
//  Copyright © 2019 Akaash Dev. All rights reserved.
//

import UIKit

func runOnMainThread(after delay: TimeInterval, operation: @escaping ()->()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: operation)
}

func runOnMainThread(operation: @escaping ()->()) {
    DispatchQueue.main.async(execute: operation)
}

extension Collection {
    
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
}

class Utils {
    
    class func getTransitioningColor(from: UIColor, to: UIColor, delta: CGFloat) -> UIColor {
        let correctedDelta = min(1, max(0, delta))
        
        var fromRed: CGFloat = 0
        var fromBlue: CGFloat = 0
        var fromGreen: CGFloat = 0
        var fromAlpha: CGFloat = 0
        from.getRed(&fromRed, green: &fromGreen, blue: &fromBlue, alpha: &fromAlpha)
        
        var toRed: CGFloat = 0
        var toBlue: CGFloat = 0
        var toGreen: CGFloat = 0
        var toAlpha: CGFloat = 0
        to.getRed(&toRed, green: &toGreen, blue: &toBlue, alpha: &toAlpha)
        
        let red = fromRed + (toRed - fromRed) * correctedDelta
        let blue = fromBlue + (toBlue - fromBlue) * correctedDelta
        let green = fromGreen + (toGreen - fromGreen) * correctedDelta
        let alpha = fromAlpha + (toAlpha - fromAlpha) * correctedDelta
        return UIColor(displayP3Red: red, green: green, blue: blue, alpha: alpha)
    }
    
}
