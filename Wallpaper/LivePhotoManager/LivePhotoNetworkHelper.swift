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
    
    class func uploadLivePhoto() {
//        // 构建对象
//        AVObject *todo = [AVObject objectWithClassName:@"Todo"];
//
//        // 为属性赋值
//        [todo setObject:@"马拉松报名" forKey:@"title"];
//        [todo setObject:@2 forKey:@"priority"];
//
//        // 将对象保存到云端
//        [todo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//            if (succeeded) {
//                // 成功保存之后，执行其他逻辑
//                NSLog(@"保存成功。objectId：%@", todo.objectId);
//            } else {
//                // 异常处理
//            }
//        }];
        
        var ret = [LCObject]()
        for i in 1...10 {
            
            for j in 1...6 {
                let categoryId = 1

                let subCategoryId = "\(categoryId)00\(j)"
                
                let todo = LCObject(className: "LivePhotosList")
                
                try? todo.set("imageName", value: "\(categoryId)_\(subCategoryId)_\(i)")
                try? todo.set("movName", value: "\(categoryId)_\(subCategoryId)_\(i)")
                try? todo.set("isHot", value: true)
                try? todo.set("isFree", value: false)
                try? todo.set("forceAdWhenDownload", value: true)

                try? todo.set("subCategoryId", value: Int(subCategoryId))

                ret.append(todo)
            }
        }
        for i in 1...20 {
            
            for j in 1...9 {
                let categoryId = 2

                let subCategoryId = "\(categoryId)00\(j)"
                
                let todo = LCObject(className: "LivePhotosList")
                
                try? todo.set("imageName", value: "\(categoryId)_\(subCategoryId)_\(i)")
                try? todo.set("movName", value: "\(categoryId)_\(subCategoryId)_\(i)")
                try? todo.set("isHot", value: true)
                try? todo.set("isFree", value: false)
                try? todo.set("forceAdWhenDownload", value: true)

                try? todo.set("subCategoryId", value: Int(subCategoryId))

                ret.append(todo)
            }
        }
        for i in 1...20 {
            
            for j in 1...6 {
                let categoryId = 3

                let subCategoryId = "\(categoryId)00\(j)"
                
                let todo = LCObject(className: "LivePhotosList")
                
                try? todo.set("imageName", value: "\(categoryId)_\(subCategoryId)_\(i)")
//                try? todo.set("movName", value: "\(categoryId)_\(subCategoryId)_\(i)")
                try? todo.set("isHot", value: true)
                try? todo.set("isFree", value: false)
                try? todo.set("forceAdWhenDownload", value: false)

                try? todo.set("subCategoryId", value: Int(subCategoryId))

                ret.append(todo)
            }
            
        }
        
        LCObject.save(ret) { (result) in
            
        }
    }
    
    class func requestLivePhotoList(in category: Int, limit: Int = LivePhotoConfig.shared.getCategoryLimited(), _ callback: @escaping ((_ list: [LivePhotoModel]?)->Void)) {
        
        let query = LCQuery(className: LeanCloud_LivePhotosList)
        query.limit = limit
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
    
    class func requestLatestLivePhotoList(limit: Int = LivePhotoConfig.shared.getCategoryLimited(), _ callback: @escaping ((_ list: [LivePhotoModel]?)->Void)) {
        let query = LCQuery(className: LeanCloud_LivePhotosList)
        query.limit = limit
        query.whereKey("updatedAt", .descending)
        query.whereKey("movName", .existed)
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
    
    class func requestHotLivePhotoList(limit: Int = LivePhotoConfig.shared.getCategoryLimited(), _ callback: @escaping ((_ list: [LivePhotoModel]?)->Void)) {
        let query = LCQuery(className: LeanCloud_LivePhotosList)
        query.limit = limit
        query.whereKey("updatedAt", .descending)
        query.whereKey("isHot", .equalTo(true))
        query.whereKey("movName", .existed)

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
        livePhoto.forceAdWhenDownload = object.get("forceAdWhenDownload")?.boolValue ?? true

        return livePhoto
    }
}
