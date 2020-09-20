//
//  LivePhotoSaveAdViewController.swift
//  Wallpaper
//
//  Created by langren on 2020/9/20.
//  Copyright © 2020 langren. All rights reserved.
//

import UIKit

class LivePhotoSaveAdViewController: UIViewController {

    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var upgradeButton: UIButton!
    @IBOutlet weak var watchAdButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        //创建一个模糊效果
        let blurEffect = UIBlurEffect(style: .light)
        //创建一个承载模糊效果的视图
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = self.view.bounds
        self.view.insertSubview(blurView, at: 0)
        
    }

 

}
