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
    
    class func likeLivePhoto(_ livePhotoName: String) {
        var names = [String]()
        if let photos = UserDefaults.standard.array(forKey: LikeUserDefaultKey) as? [String] {
            names = photos
        }
        if let _ = names.firstIndex(of: livePhotoName) {
            return
        }
        names.append(livePhotoName)
        UserDefaults.standard.set(names, forKey: LikeUserDefaultKey)
    }
    
    class func cancelLikeLivePhoto(_ livePhotoName: String) {
        var names = [String]()
        if let photos = UserDefaults.standard.array(forKey: LikeUserDefaultKey) as? [String] {
            names = photos
        }
        if let index = names.firstIndex(of: livePhotoName) {
            names.remove(at: index)
        }
        UserDefaults.standard.set(names, forKey: LikeUserDefaultKey)
    }
    
    class func isUserLike(_ livePhotoName: String) -> Bool {
        if let photos = UserDefaults.standard.array(forKey: LikeUserDefaultKey) as? [String] {
            return photos.contains(livePhotoName)
        }
        return false
    }
}


