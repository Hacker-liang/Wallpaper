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
        
        let assetIdentifier = UUID().uuidString

        let temp_savePath = LPLivePhotoSourceManager.livePhotoSavedPath(with: "\(livePhotoName)_temp_\(assetIdentifier)")
        
        group.enter()
        self.downloadFile(fileName: livePhotoName.fullImageName, savePath: savedPath.jpgSavedPath, progressChange: nil) { (data, path) in
            
            guard let _ = data, let p = path else {
                group.leave()
                imageSuccess = false
                return
            }
            let d = p.replacingOccurrences(of: "tmp", with: "jpg")
            try? FileManager.default.moveItem(atPath: p, toPath: d)

            JPEG(path: p).write(savedPath.jpgSavedPath, assetIdentifier: assetIdentifier)
            imageSuccess = true
            group.leave()
        }
        
        group.enter()
        self.downloadFile(fileName: livePhotoName.fullMovName, savePath: savedPath.movSavedPath, progressChange: progressChange) { (data, path) in
            guard let d = data else {
                group.leave()
                movSuccess = false
                return
            }
            NSLog("开始合成")
            let _ = LPLivePhotoSourceManager.saveLivePhotoData(with: d, savePath: temp_savePath.movSavedPath)
            NSLog("合成过程")
            QuickTimeMov(path: temp_savePath.movSavedPath).write(savedPath.movSavedPath, assetIdentifier: assetIdentifier)
            movSuccess = true
            NSLog("结束合成")

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
        self.downloadFile(fileName: imageName.fullImageName, savePath: savedPath, progressChange: progressChange, callback: { (data, path) in
            if let d = data {
                let _ = LPLivePhotoSourceManager.saveLivePhotoData(with: d, savePath: savedPath)
                callback(true, savedPath)
            } else {
                callback(false ,nil)
            }
        })
    }
    
    func downloadFile(fileName: String, savePath: String, progressChange:((_ value:CGFloat)->Void)?, callback: @escaping ((_ data: Data?, _ dataPath: String?) -> Void)) {
        
        let url = QiniuHelper.requestQiniuLivePhotoDownloadUrl(sourceName: fileName)
        
        let download = AF.download(url)
            .downloadProgress { progress in
                print("progress: \(progress.fractionCompleted)")
                progressChange?(CGFloat(progress.fractionCompleted))
        }
        .responseData { response in
            
            self.downloadTaskInProgress[fileName] = nil
            
            if let data = response.value, let path = response.fileURL?.path {
                callback(data, path)
                
                try? FileManager.default.removeItem(atPath: path)

            } else {
                callback(nil, nil)
            }
            
        }
        
        self.downloadTaskInProgress[fileName] = download
        
    }
}
