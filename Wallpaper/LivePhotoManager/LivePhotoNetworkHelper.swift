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
    
    fileprivate static let pageSize = 10
    
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
                callback(list.sorted{$0.categoryId ?? 0 < $1.categoryId ?? 0})
            case .failure(error: let error):
                print(error)
                callback(nil)
            }
        }
    }
    
    class func requestLivePhotoList(in category: Int, at page: Int, _ callback: @escaping ((_ list: [LivePhotoModel]?)->Void)) {
        let query = LCQuery(className: LeanCloud_LivePhotosList)
        query.limit = 10
        query.skip = pageSize*page
        query.whereKey("updatedAt", .descending)
        query.whereKey("subCategoryId", .equalTo(category))
        query.find { (result) in
            switch result {
            case .success(objects: let livePhotos):
                var list = [LivePhotoModel]()
                //livePhotos包含所有的列表
                for model in livePhotos {
                    list.append(self.parseLivePhotoData(object: model))
                }
                callback(list)
                
            case .failure(error: let error):
                print(error)
                callback(nil)
            }
        }
    }
    
    class func requestLatestLivePhotoList(at page: Int, _ callback: @escaping ((_ list: [LivePhotoModel]?)->Void)) {
        let query = LCQuery(className: LeanCloud_LivePhotosList)
        query.limit = 10
        query.skip = pageSize*page
        query.whereKey("updatedAt", .descending)
        query.find { (result) in
            switch result {
            case .success(objects: let livePhotos):
                var list = [LivePhotoModel]()
                //livePhotos包含所有的列表
                for model in livePhotos {
                    list.append(self.parseLivePhotoData(object: model))
                }
                callback(list)
                
            case .failure(error: let error):
                print(error)
                callback(nil)
            }
        }
    }
    
    class func requestHotLivePhotoList(at page: Int, _ callback: @escaping ((_ list: [LivePhotoModel]?)->Void)) {
        let query = LCQuery(className: LeanCloud_LivePhotosList)
        query.limit = 10
        query.skip = pageSize*page
        query.whereKey("updatedAt", .descending)
        query.find { (result) in
            switch result {
            case .success(objects: let livePhotos):
                var list = [LivePhotoModel]()
                //livePhotos包含所有的列表
                for model in livePhotos {
                    list.append(self.parseLivePhotoData(object: model))
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
        category.icon = object.get("icon")?.stringValue
        
        if let subCategories = object.get("subCategory")?.arrayValue as? [[String: Any]] {
            var list = [(Int, String, String?)]()
            for item in subCategories {
                if let id = item["subCategoryId"] as? Double, let name = item["subCategoryName"] as? String {
                    list.append((Int(id), name, item["icon"] as? String))
                }
            }
            
            category.subCategories = list.sorted{$0.0 < $1.0}
        }
        return category
    }
    
    class func parseLivePhotoData(object: LCObject) -> LivePhotoModel {
        let livePhoto = LivePhotoModel()
        livePhoto.imageName = object.get("imageName")?.stringValue
        livePhoto.movName = object.get("movName")?.stringValue
        return livePhoto
    }
}
