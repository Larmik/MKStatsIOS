//
//  UIColor+MKStats.swift
//  Stats MK
//
//  Created by Pascal Alberti on 17/01/2024.
//

import Foundation
import UIKit

extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hexColor: Colors) {
        self.init(
            red: (hexColor.rawValue >> 16) & 0xFF,
            green: (hexColor.rawValue >> 8) & 0xFF,
            blue: hexColor.rawValue & 0xFF)
    }
    
    convenience init(intColor: Int) {
        self.init(
            red: (intColor >> 16) & 0xFF,
            green: (intColor >> 8) & 0xFF,
            blue: intColor & 0xFF)
    }
}

