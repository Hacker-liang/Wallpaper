//
//  ViewController.swift
//  LivePhoto
//
//  Created by langren on 2020/7/9.
//  Copyright © 2020 langren. All rights reserved.
//

import UIKit
import Photos
import PhotosUI

class ViewController: UIViewController {

    var livePhotoView: PHLivePhotoView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        livePhotoView = PHLivePhotoView(frame: self.view.bounds)
        self.view.addSubview(livePhotoView)
        
        let tap = UITapGestureRecognizer()
        tap.numberOfTouchesRequired = 1
        tap.numberOfTapsRequired = 1
        tap.addTarget(self, action: #selector(livePhotoViewPress))
        livePhotoView.addGestureRecognizer(tap)
        
        
    }
    
    func updateLivePhoto(jpgName: String, movName: String) {
        guard let jpgFilePath = Bundle.main.path(forResource: jpgName, ofType: "jpg"), let movFilePath = Bundle.main.path(forResource: movName, ofType: "mov") else {
            return
        }
        let jpgUrl = URL.init(fileURLWithPath: jpgFilePath)
        let movUrl = URL.init(fileURLWithPath: movFilePath)
        PHLivePhoto.request(withResourceFileURLs: [jpgUrl,movUrl], placeholderImage: UIImage(named: "\(jpgName).jpg"), targetSize: self.livePhotoView.bounds.size, contentMode: .aspectFill) { (photo, result) in
            if let p = photo {
                self.livePhotoView.livePhoto = p
            }
        }
    }
    
    @objc func livePhotoViewPress() {
        
        self.updateLivePhoto(jpgName: "test1", movName: "test1")
//        PHPhotoLibrary.shared().performChanges({
//            let request = PHAssetCreationRequest.forAsset()
//            request.addResource(with: .photo, fileURL: jpgUrl, options: nil)
//            request.addResource(with: .pairedVideo, fileURL: movUrl, options: nil)
//
//        }) { (success, error) in
//            if success {
//                print("保存成功")
//            } else {
//                print("保存失败")
//            }
//        }
    }
    
//    func checkLivePhotoInAlbum() {
//        PHPhotoLibrary.shared().
//    }
}



extension ViewController: PHLivePhotoViewDelegate {

    func livePhotoView(_ livePhotoView: PHLivePhotoView, willBeginPlaybackWith playbackStyle: PHLivePhotoViewPlaybackStyle) {
        
    }
    
    func livePhotoView(_ livePhotoView: PHLivePhotoView, didEndPlaybackWith playbackStyle: PHLivePhotoViewPlaybackStyle) {
        
    }
    
}

