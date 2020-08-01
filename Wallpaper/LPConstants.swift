//
//  LPConstants.swift
//  Wallpaper
//
//  Created by langren on 2020/8/1.
//  Copyright © 2020 langren. All rights reserved.
//

import Foundation

let IS_PHONEPLUS: Bool = (UIScreen.main.bounds.size.width == 414)

// iPhoneX      375 * 812
// iPhoneXS     375 * 812
// iPhoneXS Max 414 * 896
// iPhoneXR     414 * 896
let IS_IPHONE_X : Bool = (UIScreen.main.bounds.size == CGSize(width: 375.0, height: 812.0) || UIScreen.main.bounds.size == CGSize(width: 812.0, height: 375.0) || UIScreen.main.bounds.size == CGSize(width: 414.0, height: 896.0) || UIScreen.main.bounds.size == CGSize(width: 896.0, height: 414.0))
