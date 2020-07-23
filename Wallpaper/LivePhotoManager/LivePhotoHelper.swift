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
    
//    class func dddrequestLivePhoto(livePhotoName: String, targetSize: CGSize, progress:((_ value:CGFloat)->Void)?, callback: @escaping ((_ livePhoto: PHLivePhoto?)->Void)) {
//        
//        let savedPath = LPLivePhotoSourceManager.livePhotoSavedPath(with: livePhotoName)
//        
//        if !LPLivePhotoSourceManager.livePhotoIsExitInSandbox(with: livePhotoName) { //如果需要重新下载
//            let download = LivePhotoDownloader()
//            download.downloadLivePhoto(savedPath: savedPath, livePhotoName: livePhotoName, progressChange: progress) { (isSuccess) in
//                if isSuccess {
//                    self.requestLivePhotoFromCache(jpgPath: savedPath.jpgSavedPath, movPath: savedPath.movSavedPath, targetSize: targetSize) { (photo) in
//                        callback(photo)
//                    }
//                } else {
//                    callback(nil)
//                }
//            }
//        } else { //直接从沙盒里获取
//            self.requestLivePhotoFromCache(jpgPath: savedPath.jpgSavedPath, movPath: savedPath.movSavedPath, targetSize: targetSize) { (photo) in
//                callback(photo)
//            }
//        }
//    }
//    
//    class func dddrequestStaticImage(imageName: String, progress:((_ value:CGFloat)->Void)?, callback: @escaping ((_ image: UIImage?)->Void)) {
//        
//        let savedPath = LPLivePhotoSourceManager.staticSavedPath(with: imageName)
//        
//        if !LPLivePhotoSourceManager.staticImageIsExitInSandbox(with: imageName) { //如果需要重新下载
//            let download = LivePhotoDownloader()
//            
//            download.downloadFile(fileName: imageName.fullImageName, savePath: savedPath, progressChange: progress) { (isSuccess, savedPath) in
//                if isSuccess, let path = savedPath {
//                    if let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
//                        callback(UIImage(data: data))
//                    } else {
//                        callback(nil)
//                    }
//                } else {
//                    callback(nil)
//                }
//            }
//        } else { //直接从沙盒里获取
//            if let data = try? Data(contentsOf: URL(fileURLWithPath: savedPath)) {
//                callback(UIImage(data: data))
//            } else {
//                callback(nil)
//            }
//        }
//    }
    
    class func requestLivePhotoFromCache(jpgPath: String, movPath: String, targetSize: CGSize, callback: @escaping ((_ livePhoto: PHLivePhoto?)->Void)) {
       
        let jpgUrl = URL.init(fileURLWithPath: jpgPath)
        let movUrl = URL.init(fileURLWithPath: movPath)
        
        PHLivePhoto.request(withResourceFileURLs: [jpgUrl,movUrl], placeholderImage: UIImage(contentsOfFile: jpgPath), targetSize: targetSize, contentMode: .aspectFill) { (photo, result) in
            callback(photo)
        }
    }
}


