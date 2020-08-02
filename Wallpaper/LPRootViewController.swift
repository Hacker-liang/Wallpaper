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
    
    var currentRewardAd: BUNativeExpressRewardedVideoAd?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        setupChildVC()
//        self.loadRewardAdIfNeeded()
    }
    
    private func loadRewardAdIfNeeded() {
        currentRewardAd = AdManager.loadRewardAd(in: self)
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
        menuVC.categoryListVC.delegate = self
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
                
                var top: CGFloat = 66.0
                
                if IS_IPHONE_X {
                    top = 106
                }
                
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

extension LPRootViewController: BUNativeExpressRewardedVideoAdDelegate {
    func nativeExpressRewardedVideoAdDidLoad(_ rewardedVideoAd: BUNativeExpressRewardedVideoAd) {
        let success = rewardedVideoAd.show(fromRootViewController: self)
        print("\(success)")
    }
    
    func nativeExpressBannerAdViewRenderFail(_ bannerAdView: BUNativeExpressBannerView, error: Error?) {
        
    }
    
    func nativeExpressRewardedVideoAdViewRenderSuccess(_ rewardedVideoAd: BUNativeExpressRewardedVideoAd) {
        
    }
    
    func nativeExpressRewardedVideoAdServerRewardDidFail(_ rewardedVideoAd: BUNativeExpressRewardedVideoAd) {
        
    }
    
    func nativeExpressRewardedVideoAdDidPlayFinish(_ rewardedVideoAd: BUNativeExpressRewardedVideoAd, didFailWithError error: Error?) {
        print("nativeExpressRewardedVideoAdDidPlayFinish")
    }
    
    func nativeExpressRewardedVideoAdServerRewardDidSucceed(_ rewardedVideoAd: BUNativeExpressRewardedVideoAd, verify: Bool) {
        print("nativeExpressRewardedVideoAdServerRewardDidSucceed")
    }
}

extension LPRootViewController: LivePhotoCategoryViewControllerDelegate {
    
    func didSelectedFindLikeCagetory() {
        self.livePhotoDetailVC.updateDataSourceWithFavoriteLivePhotos()
        self.livePhotoDetailVC.moreButton.sendActions(for: .touchUpInside)
    }
    
    func didSelectedFindNewCagetory() {
        self.livePhotoDetailVC.updateDataSourceWithNewLivePhotos()
        self.livePhotoDetailVC.moreButton.sendActions(for: .touchUpInside)

    }
    
    func didSelectedFindHotCagetory() {
        self.livePhotoDetailVC.updateDataSourceWithHotLivePhotos()
        self.livePhotoDetailVC.moreButton.sendActions(for: .touchUpInside)

    }
    
    func didSelectedCagetory(category: LivePhotoCategory, subCagetoryId: Int, subCagetoryName: String) {
        self.livePhotoDetailVC.updateDataSourcSelectedSubCategoryId(id: subCagetoryId)
        self.livePhotoDetailVC.moreButton.sendActions(for: .touchUpInside)

    }
}
