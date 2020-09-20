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
import JGProgressHUD

class LivePhotoDetailCollectionViewCell: UICollectionViewCell {

    var livePhotoView: PHLivePhotoView!
    var staticImageView: UIImageView!

    var payImageView: UIImageView!

    var currentLivePhotoModel: LivePhotoModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .black
        livePhotoView = PHLivePhotoView()
        self.addSubview(livePhotoView)
        livePhotoView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        staticImageView = UIImageView()
        staticImageView.contentMode = .scaleAspectFill
        self.addSubview(staticImageView)
        staticImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        livePhotoView.isHidden = true
        staticImageView.isHidden = true
        
        payImageView = UIImageView()
        self.addSubview(payImageView)
        payImageView.image = UIImage(named: "icon_detail_pay")
        payImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp_topMargin).offset(100)
            make.right.equalTo(-16)
            make.width.height.equalTo(43)
        }
        payImageView.isHidden = true
    }
    
    func updateLivePhoto(livePhoto: PHLivePhoto?) {
        self.livePhotoView.livePhoto = livePhoto
        self.livePhotoView.isHidden = false
        self.staticImageView.isHidden = true
    }
    
    func updateStaticPhoto(staticImage: UIImage?) {
        self.staticImageView.image = staticImage
        self.livePhotoView.isHidden = true
        self.staticImageView.isHidden = false
    }
    

}
