//
//  LivePhotoManager.swift
//  LivePhoto
//
//  Created by langren on 2020/7/9.
//  Copyright © 2020 langren. All rights reserved.
//

import UIKit
import Photos

class LivePhotoManager: NSObject {
    
    func requestLivePhotoCategory(callback:((_ category: [LivePhotoCategory])->Void)) {
        LivePhotoNetworkHelper.requseLivePhotoCagetory { list in
        }
    }
    
    func requestLivePhoto(livePhotoName: String, targetSize: CGSize, progress:((_ value:CGFloat)->Void)?, callback: @escaping ((_ livePhoto: PHLivePhoto?)->Void)) {
        let sourceManager = LPLivePhotoSourceManager()
        
        let savedPath = sourceManager.livePhotoSavedPath(with: livePhotoName)
        
        if !sourceManager.livePhotoIsExitInSandbox(with: livePhotoName) { //如果需要重新下载
            let download = LivePhotoDownloader()
            download.downloadLivePhoto(savedPath: savedPath, livePhotoName: livePhotoName, progressChange: progress) { (isSuccess) in
                if isSuccess {
                    self.requestLivePhotoFromCache(jpgPath: savedPath.jpgSavedPath, movPath: savedPath.movSavedPath, targetSize: targetSize) { (photo) in
                        callback(photo)
                    }
                } else {
                    callback(nil)
                }
            }
        } else { //直接从沙盒里获取
            self.requestLivePhotoFromCache(jpgPath: savedPath.jpgSavedPath, movPath: savedPath.movSavedPath, targetSize: targetSize) { (photo) in
                callback(photo)
            }
        }
    }
    
    fileprivate func requestLivePhotoFromCache(jpgPath: String, movPath: String, targetSize: CGSize, callback: @escaping ((_ livePhoto: PHLivePhoto?)->Void)) {
       
        let jpgUrl = URL.init(fileURLWithPath: jpgPath)
        let movUrl = URL.init(fileURLWithPath: movPath)
        
        PHLivePhoto.request(withResourceFileURLs: [jpgUrl,movUrl], placeholderImage: UIImage(contentsOfFile: jpgPath), targetSize: targetSize, contentMode: .aspectFill) { (photo, result) in
            callback(photo)
        }
    }
}


