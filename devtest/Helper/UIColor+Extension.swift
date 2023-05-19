//
//  UIColor+Extension.swift
//  devtest
//
//  Created by darindra.khadifa on 17/05/23.
//

import Foundation
import UIKit

extension UIColor {
    /**
     Creates an UIColor from HEX String in "#363636" format
     - parameter hexString: HEX String in "#363636" format
     - returns: UIColor from HexString
     */

    public convenience init(hexString: String) {
        var hexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }

        guard hexString.count == 6, let hexValue = UInt32(hexString, radix: 16) else {
            self.init(red: 0, green: 0, blue: 0, alpha: 1)
            return
        }

        let r = CGFloat((hexValue >> 16) & 0xFF) / 255.0
        let g = CGFloat((hexValue >> 8) & 0xFF) / 255.0
        let b = CGFloat(hexValue & 0xFF) / 255.0

        self.init(red: r, green: g, blue: b, alpha: 1)
    }
}

extension UIColor {
    static var mainColor: UIColor {
        UIColor(hexString: "#FFC002")
    }

    static var baseBlue: UIColor {
        UIColor(hexString: "#4472C7")
    }

    static var evenBackgroundColor: UIColor {
        UIColor(hexString: "#D0D5EB")
    }

    static var oddBackgroundColor: UIColor {
        UIColor(hexString: "#E9EBF4")
    }
}
