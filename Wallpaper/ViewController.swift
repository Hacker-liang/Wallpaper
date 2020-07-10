//
//  ViewController.swift
//  Wallpaper
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
        
//        let tap = UITapGestureRecognizer()
//        tap.numberOfTouchesRequired = 1
//        tap.numberOfTapsRequired = 1
//        tap.addTarget(self, action: #selector(livePhotoViewPress))
//        livePhotoView.addGestureRecognizer(tap)
        
        guard let jpgFilePath = Bundle.main.path(forResource: "apple", ofType: "jpg"), let jpgUrl = URL(string: jpgFilePath), let movFilePath = Bundle.main.path(forResource: "apple", ofType: "mov"), let movUrl = URL(string: movFilePath) else {
            return
        }
        PHLivePhoto.request(withResourceFileURLs: [jpgUrl,movUrl], placeholderImage: UIImage(named: "asnw.jpg"), targetSize: CGSize(width: 375, height: 667), contentMode: .aspectFill) { (photo, result) in
            if let p = photo {
                self.updateLivePhoto(livePhoto: p)
            }
        }
    }
    
    func updateLivePhoto(livePhoto: PHLivePhoto) {
        livePhotoView.livePhoto = livePhoto
    }
    
    @objc func livePhotoViewPress() {
        self.livePhotoView.startPlayback(with: .full)
    }
}



extension ViewController: PHLivePhotoViewDelegate {

    func livePhotoView(_ livePhotoView: PHLivePhotoView, willBeginPlaybackWith playbackStyle: PHLivePhotoViewPlaybackStyle) {
        
    }
    
    func livePhotoView(_ livePhotoView: PHLivePhotoView, didEndPlaybackWith playbackStyle: PHLivePhotoViewPlaybackStyle) {
        
    }
    
}

