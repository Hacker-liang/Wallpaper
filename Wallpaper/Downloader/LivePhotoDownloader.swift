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
        self.downloadFile(fileName: livePhotoName.fullImageName, savePath: savedPath.jpgSavedPath, progressChange: nil) { (isSuccess, savedPath) in
            imageSuccess = isSuccess
            group.leave()
        }
        
        group.enter()
        self.downloadFile(fileName: livePhotoName.fullMovName, savePath: savedPath.movSavedPath, progressChange: progressChange) { (isSuccess, savedPath) in
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
    
    func downloadFile(fileName: String, savePath: String, progressChange:((_ value:CGFloat)->Void)?, callback: @escaping ((_ isSuccess: Bool, _ savedPath: String?) -> Void)) {
        
        let url = QiniuHelper.requestQiniuLivePhotoDownloadUrl(sourceName: fileName)
        
        AF.download(url)
            .downloadProgress { progress in
                print("progress: \(progress)")
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
