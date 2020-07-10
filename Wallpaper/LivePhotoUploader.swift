//
//  LivePhotoUploader.swift
//  LivePhoto
//
//  Created by langren on 2020/7/10.
//  Copyright © 2020 langren. All rights reserved.
//

import UIKit
import Photos

class LivePhotoUploader: NSObject {
    func uploadLivePhoto(livePhoto: String) {
    }
    
    func uploadLivePhoto(livePhoto: PHLivePhoto) {
        let qnUploader = QiniuUplader()
        qnUploader.uploadLivePhoto(livePhoto: livePhoto)
    }
}
