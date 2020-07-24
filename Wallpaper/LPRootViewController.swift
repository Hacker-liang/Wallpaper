//
//  ViewController.swift
//  LivePhoto
//
//  Created by langren on 2020/7/9.
//  Copyright © 2020 langren. All rights reserved.
//

import UIKit
import Photos
import PhotosUI
import StoreKit

class LPRootViewController: UIViewController {
    
    var livePhotoDetailVC: LivePhotoDetailViewController!
    var menuVC: LPMenuViewController!
    
    var purchaseManager: LPPurchaseManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        setupChildVC()
    }
    
    private func setupChildVC() {
        livePhotoDetailVC = LivePhotoDetailViewController()
        livePhotoDetailVC.willMove(toParent: self)
        self.addChild(livePhotoDetailVC)
        self.view.addSubview(livePhotoDetailVC.view)
        livePhotoDetailVC.view.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(0)
            make.height.equalTo(self.view.snp.height)
        }
        livePhotoDetailVC.moreButton.addTarget(self, action: #selector(moreButtonAction), for: .touchUpInside)
        
        menuVC = LPMenuViewController()
        menuVC.willMove(toParent: self)
        self.addChild(menuVC)
        self.view.addSubview(menuVC.view)
        menuVC.view.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(0)
            make.top.equalTo(livePhotoDetailVC.view.snp.bottom)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func moreButtonAction(sender: UIButton) {
        if !sender.isSelected {
            UIView.animate(withDuration: 0.3, animations: {
                let top: CGFloat = 120.0
                
                self.livePhotoDetailVC.view.frame = CGRect(x: 0, y: top-self.livePhotoDetailVC.view.bounds.size.height, width: self.livePhotoDetailVC.view.bounds.size.width, height: self.livePhotoDetailVC.view.bounds.size.height)
                
                self.menuVC.view.frame = CGRect(x: 0, y: top, width: self.menuVC.view.bounds.size.width, height: self.view.bounds.height-top)
                
                self.livePhotoDetailVC.view.snp.updateConstraints { (make) in
                    make.top.equalToSuperview().offset(top-self.livePhotoDetailVC.view.bounds.size.height)
                }
                self.livePhotoDetailVC.hideDetail()

            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.livePhotoDetailVC.view.frame = CGRect(x: 0, y: 0, width: self.livePhotoDetailVC.view.bounds.size.width, height: self.livePhotoDetailVC.view.bounds.size.height)
                
                self.menuVC.view.frame = CGRect(x: 0, y: self.view.bounds.size.height, width: self.menuVC.view.bounds.size.width, height: 0)

                self.livePhotoDetailVC.view.snp.updateConstraints { (make) in
                    make.top.equalToSuperview().offset(0)
                }
                self.livePhotoDetailVC.showDetail()

            }, completion: nil)
        }
        sender.isSelected = !sender.isSelected
        
    }
}

