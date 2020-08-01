//
//  LivePhotoAlubmCollectionViewCell.swift
//  Wallpaper
//
//  Created by langren on 2020/7/27.
//  Copyright © 2020 langren. All rights reserved.
//

import UIKit

class LivePhotoAlubmCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        selectedImageView.isHidden = true
    }

}
