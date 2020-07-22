//
//  LivePhotoDetailCollectionViewCell.swift
//  Wallpaper
//
//  Created by langren on 2020/7/22.
//  Copyright © 2020 langren. All rights reserved.
//

import UIKit
import PhotosUI
import SDWebImage

class LivePhotoDetailCollectionViewCell: UICollectionViewCell {

    var livePhotoView: PHLivePhotoView!
    var staticImageView: UIImageView!
    var currentLivePhoto: LivePhotoModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.red
        livePhotoView = PHLivePhotoView()
        self.addSubview(livePhotoView)
        livePhotoView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        staticImageView = UIImageView()
        self.addSubview(staticImageView)
        staticImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        livePhotoView.isHidden = true
        staticImageView.isHidden = true
    }
    
    public func updateLivePhotoData(livePhoto: LivePhotoModel) {
        self.currentLivePhoto = livePhoto
        
        if livePhoto.isLivePhoto {
            livePhotoView.isHidden = false
            staticImageView.isHidden = true
            if let name = livePhoto.movName {
                LivePhotoManager.requestLivePhoto(livePhotoName: name, targetSize: self.bounds.size, progress: { [weak self] (progress) in
                    guard let weakSelf = self else {
                        return
                    }
                    
                }) { [weak self] (livePhoto) in
                    guard let weakSelf = self else {
                        return
                    }
                    if name == weakSelf.currentLivePhoto?.movName ?? "" {  //如果下载的是当前的壁纸
                        weakSelf.livePhotoView.livePhoto = livePhoto
                    }
                }

            }
            
        } else {
            livePhotoView.isHidden = true
            staticImageView.isHidden = false
            if let name = livePhoto.imageName {
                LivePhotoManager.requestStaticImage(imageName: name, progress: { (progress) in
                    
                }) { (image) in
                    self.staticImageView.image = image
                }

            }
        }
    }
    

}
