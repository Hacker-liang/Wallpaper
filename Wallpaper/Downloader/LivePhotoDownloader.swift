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
    
    var downloadTaskInProgress = [String: DownloadRequest]()

    static let shared = LivePhotoDownloader()
    
    override init() {
        super.init()
        
    }

    func cancelDownloadLivePhoto(livePhotoName: String) {
        if let imageDownload = downloadTaskInProgress[livePhotoName.fullImageName] {
            imageDownload.cancel()
        }
        if let movDownload = downloadTaskInProgress[livePhotoName.fullMovName] {
            movDownload.cancel()
        }
    }
    
    func cancelDownloadFile(fileName: String) {
        if let fileDownload = downloadTaskInProgress[fileName] {
            fileDownload.cancel()
        }
    }
    
    func downloadLivePhoto(livePhotoName: String, progressChange:((_ value:CGFloat)->Void)?, callback: @escaping ((_ isSuccess: Bool) -> Void)) {
        
        let group = DispatchGroup()
        var imageSuccess = false
        var movSuccess = false
        
        let savedPath = LPLivePhotoSourceManager.livePhotoSavedPath(with: livePhotoName)
        
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
    
    func downloadStaticImage(imageName: String, progressChange:((_ value:CGFloat)->Void)?, callback: @escaping ((_ isSuccess: Bool, _ savedPath: String?) -> Void)) {
        let savedPath = LPLivePhotoSourceManager.staticSavedPath(with: imageName)
        self.downloadFile(fileName: imageName.fullImageName, savePath: savedPath, progressChange: progressChange, callback: callback)
    }
    
    func downloadFile(fileName: String, savePath: String, progressChange:((_ value:CGFloat)->Void)?, callback: @escaping ((_ isSuccess: Bool, _ savedPath: String?) -> Void)) {
        
        let url = QiniuHelper.requestQiniuLivePhotoDownloadUrl(sourceName: fileName)

        let download = AF.download(url)
            .downloadProgress { progress in
                print("progress: \(progress.fractionCompleted)")
                progressChange?(CGFloat(progress.fractionCompleted))
        }
        .responseData { response in
            
            self.downloadTaskInProgress[fileName] = nil

            if let data = response.value, let path = response.fileURL?.path {
                if LPLivePhotoSourceManager.saveLivePhotoData(with: data, savePath: savePath) {
                    callback(true, savePath)
                } else {
                    callback(false, nil)
                }
                try? FileManager.default.removeItem(atPath: path)
                
            } else {
                callback(false, nil)
            }
        }
        self.downloadTaskInProgress[fileName] = download

    }
}
