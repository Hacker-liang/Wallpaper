//
//  LPLivePhotoSourceManager.swift
//  Wallpaper
//
//  Created by langren on 2020/7/20.
//  Copyright © 2020 langren. All rights reserved.
//

import UIKit

class LPLivePhotoSourceManager: NSObject {
    
    private let livePhotosDir = FileManager.default.temporaryDirectory.absoluteString+"/LivePhotos/"
    
    func livePhotoSavedPath(with livePhotoName: String) -> (jpgSavedPath: String, movSavedPath: String) {
        
        let imagePath = livePhotosDir+"\(livePhotoName).jpg"
        let movPath = livePhotosDir+"\(livePhotoName).mov"
        
        [imagePath, movPath].forEach { (path) in
            if !FileManager.default.fileExists(atPath: path) {
                FileManager.default.createFile(atPath: path, contents: nil, attributes: nil)
            }
        }
        
        return (imagePath, movPath)
    }
    
    func livePhotoIsExitInSandbox(with livePhotoName: String) -> Bool {
        let imagePath = livePhotosDir+"\(livePhotoName).jpg"
        let movPath = livePhotosDir+"\(livePhotoName).mov"
        return FileManager.default.fileExists(atPath: imagePath) && FileManager.default.fileExists(atPath: movPath)
    }
    
    func saveLivePhotoData(with data: Data, savePath: String) -> Bool {
        
        return true
    }

}
