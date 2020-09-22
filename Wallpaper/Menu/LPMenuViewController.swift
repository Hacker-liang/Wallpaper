//
//  LPMenuViewController.swift
//  Wallpaper
//
//  Created by langren on 2020/7/24.
//  Copyright © 2020 langren. All rights reserved.
//

import UIKit

class LPMenuViewController: UIViewController {

//    var segmentControl: LPSegmentView!
    
    let dataSource = ["分类", "高级版", "设置中心"]
    let normalImageName = ["icon_menu_category_normal", "icon_menu_advance_normal", "icon_menu_setting_normal"]
    let selectedImageName = ["icon_menu_category_selected", "icon_menu_advance_selected", "icon_menu_setting_selected"]

    var vipBannerView: UIImageView!
    var tapGesture: UITapGestureRecognizer!
    
    var categoryListVC: LivePhotoCategoryViewController!
    
    init() {
        categoryListVC = LivePhotoCategoryViewController()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        setupContentView()
        
        tapGesture = UITapGestureRecognizer()
        tapGesture.numberOfTouchesRequired = 1
        tapGesture.numberOfTapsRequired = 1
        tapGesture.addTarget(self, action: #selector(vipBannerTapAction))
        self.vipBannerView.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
//        self.segmentControl.markSelected(at: 0)
    }
    
    @objc func vipBannerTapAction() {
        let ct: UIViewController!
        if LPAccount.shared.isVip {
            ct = LPAdvanceViewController()
        } else {
            ct = LPUpgradeViewController()
        }
        ct.modalPresentationStyle = .fullScreen
        self.present(ct, animated: true, completion: nil)
    }
    
    private func gotoSettingVC() {
        let settingVC = LPSettingViewController()
        settingVC.modalPresentationStyle = .fullScreen
        self.present(settingVC, animated: true, completion: nil)
    }
    
    private func gotoPurchaseVC() {
        let purchaseVC = LPUpgradeViewController()
        purchaseVC.modalPresentationStyle = .fullScreen
        self.present(purchaseVC, animated: true, completion: nil)
    }
    
    private func gotoAdvanceVC() {
        let advanceVC = LPAdvanceViewController()
        advanceVC.modalPresentationStyle = .fullScreen
        self.present(advanceVC, animated: true, completion: nil)
    }
    
    private func updateVipStatus() {
        vipBannerView.snp.updateConstraints { (make) in
            if LPAccount.shared.isVip {
                make.height.equalTo(0)

            } else {
                make.height.equalTo(107)
            }
        }
    }
    
    private func setupContentView() {
//        segmentControl = LPSegmentView(titles: dataSource, normalImageNames: normalImageName, selectedImageNames: selectedImageName)
//        segmentControl.delegate = self
//        segmentControl.markSelected(at: 0)
//
//        self.view.addSubview(segmentControl)
//
//        segmentControl.snp.makeConstraints { (make) in
//            make.leading.top.equalToSuperview()
//            make.width.equalTo(290.0)
//            make.height.equalTo(55)
//        }
        
        vipBannerView = UIImageView()
        vipBannerView.isUserInteractionEnabled = true
        vipBannerView.image = UIImage(named: "icon_menu_vipbanner")
        self.view.addSubview(vipBannerView)
        vipBannerView.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(107)
        }
        
        categoryListVC.willMove(toParent: self)
        self.addChild(categoryListVC)
        self.view.addSubview(categoryListVC.view)
        categoryListVC.view.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(vipBannerView.snp.bottom)
        }
    }
    
}


