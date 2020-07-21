//
//  LivePhotoDownloader.swift
//  LivePhoto
//
//  Created by langren on 2020/7/9.
//  Copyright © 2020 langren. All rights reserved.
//

import UIKit
import Alamofire

class LivePhotoDownloader: NSObject {
    
    func downloadLivePhoto(savedPath:(jpgSavedPath: String, movSavedPath: String), livePhotoName: String, progressChange:((_ value:CGFloat)->Void)?, callback: @escaping ((_ isSuccess: Bool) -> Void)) {
        
        let group = DispatchGroup()
        var imageSuccess = false
        var movSuccess = false

        group.enter()
        self.downloadStaticImage(imageName: "\(livePhotoName).jpg", savePath: savedPath.jpgSavedPath, progressChange: nil) { (isSuccess, savedPath) in
            imageSuccess = isSuccess
            group.leave()
        }
        
        group.enter()
        self.downloadMovFile(movName: "\(livePhotoName).mov", savePath: savedPath.movSavedPath, progressChange: progressChange) { (isSuccess, savedPath) in
            movSuccess = isSuccess
            group.leave()
        }
        
        group.notify(queue: DispatchQueue.main) {
            if imageSuccess&&movSuccess {
                callback(true)
            } else {
                callback(false)
            }
        }
    }
    
    func downloadStaticImage(imageName: String, savePath: String, progressChange:((_ value:CGFloat)->Void)?, callback: @escaping ((_ isSuccess: Bool, _ savedPath: String?) -> Void)) {
        
        let destination: DownloadRequest.Destination = { _, _ in
            return (URL(fileURLWithPath: savePath), [.removePreviousFile, .createIntermediateDirectories])
        }
        let url = QiniuHelper.requestQiniuLivePhotoDownloadUrl(sourceName: imageName)
        
        AF.download(url, to: destination).response { response in
            debugPrint(response)

            if response.error == nil, let imagePath = response.fileURL?.path {
                callback(true, imagePath)
            } else {
                callback(false, nil)
            }
        }
    }
    
    func downloadMovFile(movName: String, savePath: String, progressChange: ((_ value:CGFloat)->Void)?, callback: @escaping ((_ isSuccess: Bool, _ savedPath: String?) -> Void)) {
       
        let url = QiniuHelper.requestQiniuLivePhotoDownloadUrl(sourceName: movName)
        
        AF.download(url)
        .downloadProgress { progress in
            progressChange?(CGFloat(progress.fractionCompleted))
        }
        .responseData { response in
            if let data = response.value, let path = response.fileURL?.path {
                if LPLivePhotoSourceManager().saveLivePhotoData(with: data, savePath: savePath) {
                    callback(true, savePath)
                } else {
                    callback(false, nil)
                }
                try? FileManager.default.removeItem(atPath: path)
            } else {
                callback(false, nil)
            }
        }
    }
     
}
