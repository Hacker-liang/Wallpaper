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
    var purchaseManager: LPPurchaseManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        livePhotoDetailVC = LivePhotoDetailViewController()
        livePhotoDetailVC.willMove(toParent: self)
        self.addChild(livePhotoDetailVC)
        self.view.addSubview(livePhotoDetailVC.view)
        livePhotoDetailVC.view.snp.makeConstraints { (make) in
            make.top.bottom.leading.trailing.equalTo(0)
        }
        
        livePhotoDetailVC.moreButton.addTarget(self, action: #selector(moreButtonAction), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
   
    @objc func moreButtonAction(sender: UIButton) {
        if !sender.isSelected {
            UIView.animate(withDuration: 0.3, animations: {
                self.livePhotoDetailVC.view.frame = CGRect(x: 0, y: 200-self.livePhotoDetailVC.view.bounds.size.height, width: self.livePhotoDetailVC.view.bounds.size.width, height: self.livePhotoDetailVC.view.bounds.size.height)
                self.livePhotoDetailVC.view.snp.updateConstraints { (make) in
                    make.top.equalToSuperview().offset(200-self.livePhotoDetailVC.view.bounds.size.height)
                }
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.livePhotoDetailVC.view.frame = CGRect(x: 0, y: 0, width: self.livePhotoDetailVC.view.bounds.size.width, height: self.livePhotoDetailVC.view.bounds.size.height)
                self.livePhotoDetailVC.view.snp.updateConstraints { (make) in
                    make.top.equalToSuperview().offset(0
                    )
                }
            }, completion: nil)
        }
        sender.isSelected = !sender.isSelected
        
    }
}

