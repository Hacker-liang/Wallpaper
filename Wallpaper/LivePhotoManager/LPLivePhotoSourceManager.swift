//
//  LPLivePhotoSourceManager.swift
//  Wallpaper
//
//  Created by langren on 2020/7/20.
//  Copyright © 2020 langren. All rights reserved.
//

import UIKit

class LPLivePhotoSourceManager: NSObject {
    
    let livePhotosDir = (NSTemporaryDirectory() as NSString).appendingPathComponent("LivePhotos")

    func livePhotoSavedPath(with livePhotoName: String) -> (jpgSavedPath: String, movSavedPath: String) {
    
        let imagePath = (livePhotosDir as NSString).appendingPathComponent("\(livePhotoName).jpg")
        let movPath = (livePhotosDir as NSString).appendingPathComponent("\(livePhotoName).mov")

        if !FileManager.default.fileExists(atPath: livePhotosDir) {
            try? FileManager.default.createDirectory(atPath: livePhotosDir, withIntermediateDirectories: true, attributes: nil)
        }
        
        return (imagePath, movPath)
    }
    
    func livePhotoIsExitInSandbox(with livePhotoName: String) -> Bool {
        let imagePath = (livePhotosDir as NSString).appendingPathComponent("\(livePhotoName).jpg")
        let movPath = (livePhotosDir as NSString).appendingPathComponent("\(livePhotoName).mov")
        return FileManager.default.fileExists(atPath: imagePath) && FileManager.default.fileExists(atPath: movPath)
    }
    
    func saveLivePhotoData(with data: Data, savePath: String) -> Bool {
        FileManager.default.createFile(atPath: savePath, contents: data, attributes: nil)
        return true
    }

}
