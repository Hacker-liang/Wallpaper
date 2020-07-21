//
//  LivePhotoNetworkHelper.swift
//  Wallpaper
//
//  Created by langren on 2020/7/20.
//  Copyright © 2020 langren. All rights reserved.
//

import UIKit
import LeanCloud

class LivePhotoNetworkHelper: NSObject {
    
    fileprivate static let LeanCloud_LivePhotosCategoryClass = "LivePhotosCategory"
    fileprivate static let LeanCloud_LivePhotosList = "LivePhotosList"

    class func requseLivePhotoCagetory(_ callback: @escaping ((_ list: [LivePhotoCategory]?)->Void)) {
        
        let query = LCQuery(className: LeanCloud_LivePhotosCategoryClass)
        
        query.limit = 100
        
        query.find { (result) in
            switch result {
            case .success(objects: let categories):
                var list = [LivePhotoCategory]()
                // categories 包含所有的列表
                for category in categories {
                    list.append(self.parseCategoryData(object: category))
                }
                callback(list)
            case .failure(error: let error):
                print(error)
                callback(nil)
            }
        }
    }
    
    class func parseCategoryData(object: LCObject) -> LivePhotoCategory {
        let category = LivePhotoCategory()
        category.categoryId = object.get("categoryId")?.intValue
        category.categoryName = object.get("categoryName")?.stringValue
        category.isFree = object.get("categoryIsFree")?.boolValue
        if let subCategories = object.get("subCategory")?.arrayValue as? [[String: Any]] {
            var list = [(Int, String)]()
            for item in subCategories {
                if let id = item["subCategoryId"] as? Double, let name = item["subCategoryName"] as? String {
                    list.append((Int(id), name))
                }
            }
            category.subCategories = list
        }
        return category
        
    }
}
