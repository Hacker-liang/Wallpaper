//
//  LPSettingViewController.swift
//  Wallpaper
//
//  Created by langren on 2020/7/24.
//  Copyright © 2020 langren. All rights reserved.
//

import UIKit
import JGProgressHUD
import SDWebImage

class LPSettingViewController: UIViewController {
    
    var segmentControl: LPSegmentView!
    var contentTextView: UITextView!
    
    var privacyCtl: LivePhotoPrivacyContentViewController!

    
    var segmentSelectedIndex = 2

    let dataSource = ["分享APP", "清除缓存", "隐私政策", "使用条款", "帮助中心"]

    let images = ["icon_setting_share","icon_setting_clean","icon_setting_privacy","icon_setting_guidline","icon_setting_help"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray
        setupContentView()
    }
    
    private func setupContentView() {
        
        let toolbar = UIImageView(image: UIImage(named: "icon_setting_toolbar_bg"))
        toolbar.isUserInteractionEnabled = true
        self.view.addSubview(toolbar)
        toolbar.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(0)
            make.height.equalTo(IS_IPHONE_X ? 100:88)
        }
        
        privacyCtl = LivePhotoPrivacyContentViewController()
        privacyCtl.willMove(toParent: self)
        self.addChild(privacyCtl)
        self.view.addSubview(privacyCtl.view)
        privacyCtl.contentTextView.text = privacyCtl.privacyContent()
        privacyCtl.view.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(0)
            make.bottom.equalTo(toolbar.snp.top)
        }
        
        let diamondButton = UIButton()
        diamondButton.setImage(UIImage(named: "icon_setting_diamond"), for: .normal)
        diamondButton.addTarget(self, action: #selector(diamondButtonAction), for: .touchUpInside)
        toolbar.addSubview(diamondButton)
        diamondButton.snp.makeConstraints { (make) in
            make.leading.equalTo(4)
            make.top.equalTo(7)
            make.width.equalTo(62)
            make.height.equalTo(57)
        }
        
        let proImageView = UIImageView()
        proImageView.image = UIImage(named: "icon_setting_pro")
        toolbar.addSubview(proImageView)
        proImageView.snp.makeConstraints { (make) in
            make.leading.equalTo(17)
            make.top.equalTo(55)
            make.width.equalTo(30)
            make.height.equalTo(14)
        }
        
        segmentControl = LPSegmentView(titles: dataSource, normalImageNames: images, selectedImageNames: images)
        
        segmentControl.backgroundColor = .clear
        segmentControl.updateTitleFont(font: UIFont.systemFont(ofSize: 10.0))
        segmentControl.delegate = self
        
        toolbar.addSubview(segmentControl)
        
        segmentControl.snp.makeConstraints { (make) in
            make.trailing.equalTo(0)
            make.top.equalTo(11.0)
            make.height.equalTo(57)
            make.leading.equalTo(66)
        }
        
        segmentControl.markSelected(at: segmentSelectedIndex)
    }
    
    private func shareApp() {
        let text = "3D动态壁纸"
        let imageToShare = UIImage(named: "icon_share_logo")
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
        }
    }
    
    private func cleanApp() {
        let hud = JGProgressHUD(style: .dark)
        hud.show(in: self.view)
        LPLivePhotoSourceManager.clearCache()
        SDImageCache.shared.clearDisk {
            hud.dismiss()
            self.view.makeToast("清理成功", duration: 1.0, position: CSToastPositionCenter)
        }
      
    }
    
    @objc func diamondButtonAction() {
        let ct: UIViewController!
        if LPAccount.shared.isVip {
            ct = LPAdvanceViewController()
        } else {
            ct = LPUpgradeViewController()
        }
        ct.modalPresentationStyle = .fullScreen
        self.present(ct, animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension LPSettingViewController: LPSegmentViewDelegate {
    
    func didSelected(at index: Int) {
        if index == 0 {
            shareApp()
            self.segmentControl.markSelected(at: segmentSelectedIndex)
        } else if index == 1 {
            self.segmentControl.markSelected(at: segmentSelectedIndex)
            cleanApp()
        } else {
            self.segmentSelectedIndex = index
            self.updateContent()
        }
    }
    
    func updateContent() {
        if self.segmentSelectedIndex == 2 {
            privacyCtl.contentTextView.text = privacyCtl.privacyContent()
        } else if self.segmentSelectedIndex == 3 {
            privacyCtl.contentTextView.text = privacyCtl.guidlineContent()
        } else if self.segmentSelectedIndex == 4 {
            privacyCtl.contentTextView.text = privacyCtl.helpContent()
        }
    }
}


