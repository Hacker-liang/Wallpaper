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
    
    var purchaseManager: LPPurchaseManager!
    
    var livePhotoManager: LivePhotoManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        livePhotoView = PHLivePhotoView(frame: self.view.bounds)
        
        livePhotoManager = LivePhotoManager()
        
        self.view.insertSubview(livePhotoView, at: 0)
//
//        let tap = UITapGestureRecognizer()
//        tap.numberOfTouchesRequired = 1
//        tap.numberOfTapsRequired = 1
//        tap.addTarget(self, action: #selector(livePhotoViewPress))
//        livePhotoView.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func purchaseButtonAction(_ sender: Any) {
       
        livePhotoManager.requestLivePhoto(livePhotoName: "test1", targetSize: CGSize(width: 720, height: 1280), progress: { (progress) in
            print("下载进度为：\(progress)")
            
        }) { (livePhoto) in
            if let p = livePhoto {
                self.livePhotoView.livePhoto = p
            }
        }
    }
    
    func updateLivePhoto(jpgName: String, movName: String) {
        
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

