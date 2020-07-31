//
//  LivePhotoCategory.swift
//  Wallpaper
//
//  Created by langren on 2020/7/20.
//  Copyright © 2020 langren. All rights reserved.
//

import UIKit

//let DefaultLivePhotoCategory_Id = "1000000000"
//let DefaultLivePhotoCategory_Name = "默认分类"
//let DefaultLivePhotoSubCategory_New_Id = "1000000001"
//let DefaultLivePhotoSubCategory_Hot_Id = "1000000002"
//let DefaultLivePhotoSubCategory_Like_Id = "1000000003"
//let DefaultLivePhotoSubCategory_New_Name = "发现最新"
//let DefaultLivePhotoSubCategory_Hot_Name = "热门推荐"
//let DefaultLivePhotoSubCategory_Like_Name = "收藏影集"

class LivePhotoCategory: NSObject {

    var categoryId: Int?
    var categoryName: String?
    var icon: String?
    var isFree: Bool?
    var subCategories = [(subCategoryId: Int, subCategoryName: String, icon: String?)]()
    
}

extension LivePhotoCategory {
    
//    var defaultCagetory: LivePhotoCategory {
//        get {
//            let category = LivePhotoCategory()
//            category.categoryId = 1
//        }
//    }
}
