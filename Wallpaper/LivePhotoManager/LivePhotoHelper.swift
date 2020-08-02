//
//  LivePhotoHelper.swift
//  LivePhoto
//
//  Created by langren on 2020/7/9.
//  Copyright © 2020 langren. All rights reserved.
//

import UIKit
import Photos

class LivePhotoHelper: NSObject {
    
    private static let LikeUserDefaultKey = "LikeUserDefaultKey"

    class func requestLivePhotoFromCache(jpgPath: String, movPath: String, targetSize: CGSize, callback: @escaping ((_ livePhoto: PHLivePhoto?)->Void)) {
       
        let jpgUrl = URL.init(fileURLWithPath: jpgPath)
        let movUrl = URL.init(fileURLWithPath: movPath)
        
        PHLivePhoto.request(withResourceFileURLs: [jpgUrl,movUrl], placeholderImage: UIImage(contentsOfFile: jpgPath), targetSize: targetSize, contentMode: .aspectFill) { (photo, result) in
            callback(photo)
        }
    }
    
    class func likeLivePhoto(_ livePhoto: LivePhotoModel) {
        var names = [[String: String]]()
        if let photos = UserDefaults.standard.array(forKey: LikeUserDefaultKey) as? [[String: String]] {
            names = photos
        }
        if let _ = names.first(where: { (item) -> Bool in
            item["name"] == livePhoto.imageName
        }) {
            return
        }
        
        names.append(["imageName":livePhoto.imageName ?? "", "movName":livePhoto.movName ?? ""])
        UserDefaults.standard.set(names, forKey: LikeUserDefaultKey)
    }
    
    class func requestUserLiveLivePhotos() -> [LivePhotoModel] {
        
        guard let photos = UserDefaults.standard.array(forKey: LikeUserDefaultKey) as? [[String: String]] else {
            return []
        }
        var ret = [LivePhotoModel]()
        for item in photos {
            let model = LivePhotoModel()
            model.imageName = item["imageName"]
            if (item["movName"]?.count ?? 0) > 0 {
                model.movName = item["movName"]
            }
            ret.append(model)
        }
        return ret
    }
    
    class func cancelLikeLivePhoto(_ livePhoto: LivePhotoModel) {
        var names = [[String: String]]()
        if let photos = UserDefaults.standard.array(forKey: LikeUserDefaultKey) as? [[String: String]] {
            names = photos
        }
        
        if let index = names.firstIndex(where: { (item) -> Bool in
            item["imageName"] == livePhoto.imageName
        }) {
            names.remove(at: index)
        }
        UserDefaults.standard.set(names, forKey: LikeUserDefaultKey)
    }
    
    class func isUserLike(_ livePhoto: LivePhotoModel) -> Bool {
        if let photos = UserDefaults.standard.array(forKey: LikeUserDefaultKey) as? [[String: String]] {
            return photos.contains { (item) -> Bool in
                return item["imageName"] == livePhoto.imageName
            }
        }
        return false
    }
}


