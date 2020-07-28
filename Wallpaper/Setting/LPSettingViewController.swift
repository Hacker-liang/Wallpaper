//
//  LPSettingViewController.swift
//  Wallpaper
//
//  Created by langren on 2020/7/24.
//  Copyright © 2020 langren. All rights reserved.
//

import UIKit

class LPSettingViewController: UIViewController {
    
    var segmentControl: LPSegmentView!
       
    let dataSource = ["分享APP", "清除缓存", "隐私政策", "使用条款", "帮助中心"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray
        setupContentView()
    }
    
    private func setupContentView() {
        segmentControl = LPSegmentView(titles: dataSource, normalImageNames: dataSource, selectedImageNames: dataSource)
        segmentControl.backgroundColor = .black
        segmentControl.updateTitleFont(font: UIFont.systemFont(ofSize: 10.0))
        segmentControl.delegate = self
        segmentControl.markSelected(at: 2)
        
        self.view.addSubview(segmentControl)
        
        segmentControl.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalTo(0)
            make.height.equalTo(50)
        }
    }
    
    private func shareApp() {
        let text = "分享标题"
        let imageToShare = UIImage(named: "Image")
        let url = URL(string: "https://itunes.apple.com/app/id1483414458")
        
        let activityItems = [text, imageToShare, url] as [Any?]
        
        let activityVC = UIActivityViewController(activityItems: activityItems as [Any], applicationActivities: nil)
        
        activityVC.excludedActivityTypes = [.message, .mail, .copyToPasteboard, .assignToContact, .saveToCameraRoll]
        self.present(activityVC, animated: true, completion: nil)
        activityVC.completionWithItemsHandler = {(type, completed, returnedItems, activityError) in
            if completed {
                print("分享成功")
            } else {
                print("分享失败")
            }
            self.segmentControl.markSelected(at: 3)
        }
    }
}

extension LPSettingViewController: LPSegmentViewDelegate {
    
    func didSelected(at index: Int) {
        if index == 0 {
            shareApp()
        }
    }
}
