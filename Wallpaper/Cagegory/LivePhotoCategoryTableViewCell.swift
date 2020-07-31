//
//  LivePhotoCategoryTableViewCell.swift
//  Wallpaper
//
//  Created by langren on 2020/7/31.
//  Copyright © 2020 langren. All rights reserved.
//

import UIKit

class LivePhotoCategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var selectedImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
