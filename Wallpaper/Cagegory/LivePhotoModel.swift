//
//  LivePhotoModel.swift
//  Wallpaper
//
//  Created by langren on 2020/7/20.
//  Copyright © 2020 langren. All rights reserved.
//

import UIKit

class LivePhotoModel: NSObject {
    
    var imageName: String?
    
    var movName: String?
    
    var isLivePhoto: Bool {
        get {
            return self.movName != nil
        }
    }

    var associateSubCategoryId: Int?
}
