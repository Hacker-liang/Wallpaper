//
//  LPMenuViewController.swift
//  Wallpaper
//
//  Created by langren on 2020/7/24.
//  Copyright © 2020 langren. All rights reserved.
//

import UIKit

class LPMenuViewController: UIViewController {

    var segmentControl: LPSegmentView!
    
    let dataSource = ["分类", "高级版", "设置中心"]
    let normalImageName = ["icon_menu_category_normal", "icon_menu_advance_normal", "icon_menu_setting_normal"]
    let selectedImageName = ["icon_menu_category_selected", "icon_menu_advance_selected", "icon_menu_setting_selected"]

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
        self.view.backgroundColor = .black
        setupContentView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.segmentControl.markSelected(at: 0)
    }
    
    private func gotoSettingVC() {
        let settingVC = LPSettingViewController()
//        settingVC.modalPresentationStyle = .fullScreen
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
    
    private func setupContentView() {
        segmentControl = LPSegmentView(titles: dataSource, normalImageNames: normalImageName, selectedImageNames: selectedImageName)
        segmentControl.delegate = self
        segmentControl.markSelected(at: 0)
        
        self.view.addSubview(segmentControl)
        
        segmentControl.snp.makeConstraints { (make) in
            make.leading.top.equalToSuperview()
            make.width.equalTo(290.0)
            make.height.equalTo(55)
        }
        
        categoryListVC.willMove(toParent: self)
        self.addChild(categoryListVC)
        self.view.addSubview(categoryListVC.view)
        categoryListVC.view.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(segmentControl.snp.bottom)
        }
    }
    
}

extension LPMenuViewController: LPSegmentViewDelegate {
    func didSelected(at index: Int) {
        if index == 0 { //显示分类
            
        } else if index == 1 { //显示VIP页面
            if !LPAccount.shared.isVip {
                gotoPurchaseVC()
            } else {
                gotoAdvanceVC()
            }
        } else if index == 2 {  //显示设置页面
            gotoSettingVC()
        }
    }
}
