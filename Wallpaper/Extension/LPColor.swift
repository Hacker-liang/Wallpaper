//
//  LPColor.swift
//  Wallpaper
//
//  Created by langren on 2020/7/24.
//  Copyright © 2020 langren. All rights reserved.
//

import Foundation

extension UIColor {
    class func rgb(_ value: Int) -> UIColor {
        return UIColor(red: CGFloat((value & 0xFF0000) >> 16)/255.0, green: CGFloat((value & 0xFF00) >> 8)/255.0, blue: CGFloat((value & 0xFF))/255.0, alpha: 1.0)
        
    }

    class func rgba(_ value: Int, alpha: CGFloat) -> UIColor {
        return UIColor(red: CGFloat((value & 0xFF0000) >> 16)/255.0, green: CGFloat((value & 0xFF00) >> 8)/255.0, blue: CGFloat((value & 0xFF))/255.0, alpha: alpha)
    }
}

