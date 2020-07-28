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
    
    var imageUrl: String? {
        get {
            if let name = self.imageName {
                return QiniuHelper.requestQiniuLivePhotoDownloadUrl(sourceName: name.fullImageName)
            } else {
                return nil
            }
        }
    }
    
    var coverImageUrl: String? {
        get {
            if let name = self.imageName {
                return QiniuHelper.requestQiniuCoverImageDownloadUrl(imageName: name.fullImageName)
            } else {
                return nil
            }
        }
    }
    
    var movUrl: String? {
        get {
            if let name = self.movName {
                return QiniuHelper.requestQiniuLivePhotoDownloadUrl(sourceName: name.fullMovName)
            } else {
                return nil
            }
        }
    }
}

extension String {
    var fullImageName: String {
        get {
            return "\(self).jpg"
        }
    }
    
    var fullMovName: String {
        get {
            return "\(self).mov"
        }
    }
}
