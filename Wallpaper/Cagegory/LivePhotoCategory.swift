//
//  LivePhotoCategory.swift
//  Wallpaper
//
//  Created by langren on 2020/7/20.
//  Copyright © 2020 langren. All rights reserved.
//

import UIKit

class LivePhotoCategory: NSObject {

    var categoryId: Int?
    var categoryName: String?
    var icon: String?
    var isFree: Bool?
    var subCategories = [(subCategoryId: Int, subCategoryName: String, icon: String?)]()
    
}
