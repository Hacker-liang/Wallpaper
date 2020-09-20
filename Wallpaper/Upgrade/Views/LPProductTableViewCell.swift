//
//  LPProductTableViewCell.swift
//  Wallpaper
//
//  Created by langren on 2020/7/29.
//  Copyright © 2020 langren. All rights reserved.
//

import UIKit

class LPProductTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectedImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        bgView.backgroundColor = .clear
        bgView.layer.borderWidth = 1.0
        bgView.layer.cornerRadius = 20.5
        bgView.layer.borderColor = UIColor.white.cgColor
        selectedImageView.isHidden = true
        titleLabel.adjustsFontSizeToFitWidth = true
        descLabel.adjustsFontSizeToFitWidth = true
    }

    func userSelected(_ selected: Bool) {
        if selected {
            bgView.layer.borderColor = UIColor.rgb(0xD79933).cgColor
            selectedImageView.isHidden = false
        } else {
            bgView.layer.borderColor = UIColor.white.cgColor
            selectedImageView.isHidden = true
        }
    }
    
}
