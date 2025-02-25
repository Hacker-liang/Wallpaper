//
//  LPLivePhotoSourceManager.swift
//  Wallpaper
//
//  Created by langren on 2020/7/20.
//  Copyright © 2020 langren. All rights reserved.
//

import UIKit

class LPLivePhotoSourceManager: NSObject {
    
    static let livePhotosDir = (NSTemporaryDirectory() as NSString).appendingPathComponent("LivePhotos")
    static let staticPhotosDir = (NSTemporaryDirectory() as NSString).appendingPathComponent("StaticPhotos")

    class func livePhotoSavedPath(with livePhotoName: String) -> (jpgSavedPath: String, movSavedPath: String) {
    
        let imagePath = (livePhotosDir as NSString).appendingPathComponent(livePhotoName.fullImageName)
        let movPath = (livePhotosDir as NSString).appendingPathComponent(livePhotoName.fullMovName)

        if !FileManager.default.fileExists(atPath: livePhotosDir) {
            try? FileManager.default.createDirectory(atPath: livePhotosDir, withIntermediateDirectories: true, attributes: nil)
        }
        return (imagePath, movPath)
    }
    
    class func staticSavedPath(with imageName: String) -> String {
        let imagePath = (staticPhotosDir as NSString).appendingPathComponent(imageName.fullImageName)
        if !FileManager.default.fileExists(atPath: staticPhotosDir) {
            try? FileManager.default.createDirectory(atPath: staticPhotosDir, withIntermediateDirectories: true, attributes: nil)
        }
        return imagePath
    }
    
    class func livePhotoIsExitInSandbox(with livePhotoName: String) -> Bool {
        let imagePath = (livePhotosDir as NSString).appendingPathComponent(livePhotoName.fullImageName)
        let movPath = (livePhotosDir as NSString).appendingPathComponent(livePhotoName.fullMovName)
        return FileManager.default.fileExists(atPath: imagePath) && FileManager.default.fileExists(atPath: movPath)
    }
    
    class func staticImageIsExitInSandbox(with imageName: String) -> Bool {
        let imagePath = (staticPhotosDir as NSString).appendingPathComponent(imageName.fullImageName)
        return FileManager.default.fileExists(atPath: imagePath)
    }
    
    class func saveLivePhotoData(with data: Data, savePath: String) -> Bool {
        FileManager.default.createFile(atPath: savePath, contents: data, attributes: nil)
        return true
    }
    
    class func clearCache() {
        do {
            try FileManager.default.removeItem(atPath: livePhotosDir)
            try FileManager.default.removeItem(atPath: staticPhotosDir)
        } catch {
            print("clearCache FAIL")
        }
    }

}
