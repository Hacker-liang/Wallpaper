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
    
    var tapGesture: UITapGestureRecognizer?
    
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
            make.top.leading.equalTo(0)
            make.width.equalTo(self.view.snp.width)
            make.height.equalTo(self.view.snp.height)
        }
        livePhotoDetailVC.moreButton.addTarget(self, action: #selector(moreButtonAction), for: .touchUpInside)
        livePhotoDetailVC.settingButton.addTarget(self, action: #selector(settingButtonAction), for: .touchUpInside)
        
        menuVC = LPMenuViewController()
        menuVC.categoryListVC.delegate = self
        menuVC.willMove(toParent: self)
        self.addChild(menuVC)
        self.view.addSubview(menuVC.view)
        menuVC.view.snp.makeConstraints { (make) in
            make.top.equalTo(48)
            make.bottom.equalTo(0)
            make.leading.equalTo(0).offset(-290)
            make.width.equalTo(290)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func settingButtonAction(sender: UIButton) {
        let settingVC = LPSettingViewController()
        settingVC.modalPresentationStyle = .fullScreen
        self.present(settingVC, animated: true, completion: nil)
    }
    
    @objc func moreButtonAction(sender: UIButton) {
        if !sender.isSelected {
            self.showMenuVC()
        } else {
            self.hideMenuVC()
        }
    }
    
    private func showMenuVC() {
        UIView.animate(withDuration: 0.2, animations: {
            
            self.menuVC.view.frame = CGRect(x: 0, y: self.menuVC.view.frame.origin.y, width:  self.menuVC.view.bounds.size.width, height: self.view.bounds.height)
            
            self.menuVC.view.snp.updateConstraints { (make) in
                make.leading.equalTo(0)
            }
            
        }, completion:{ (finish) in
        })
        self.livePhotoDetailVC.hideDetail()
        tapGesture = UITapGestureRecognizer()
        tapGesture?.numberOfTouchesRequired = 1
        tapGesture?.numberOfTapsRequired = 1
        tapGesture?.addTarget(self, action: #selector(detailVCTapAction))
        self.livePhotoDetailVC.view.addGestureRecognizer(tapGesture!)
        self.livePhotoDetailVC.moreButton.isSelected = true
    }
    
    private func hideMenuVC() {
        UIView.animate(withDuration: 0.2, animations: {
            
            self.menuVC.view.frame = CGRect(x: -self.menuVC.view.bounds.size.width, y:self.menuVC.view.frame.origin.y , width: self.menuVC.view.bounds.size.width, height: 0)
            
            self.menuVC.view.snp.updateConstraints { (make) in
                make.leading.equalTo(0).offset(-290)
            }
            
        }, completion: { (finish) in
        })
        self.livePhotoDetailVC.showDetail()
        if let gesture = tapGesture {
            self.livePhotoDetailVC.view.removeGestureRecognizer(gesture)
            tapGesture = nil
        }
        self.livePhotoDetailVC.moreButton.isSelected = false
        
    }
    
    @objc func detailVCTapAction() {
        self.hideMenuVC()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
        let galleryVC = LivePhotoGalleryViewController()
        galleryVC.modalPresentationStyle = .fullScreen
        galleryVC.delegate = self
        self.present(galleryVC, animated: true, completion: nil)
        galleryVC.updateDataSourceWithFavoriteLivePhotos()
        self.livePhotoDetailVC.updateDataSourceWithFavoriteLivePhotos()
    }
    
    func didSelectedFindNewCagetory() {
        let galleryVC = LivePhotoGalleryViewController()
        galleryVC.modalPresentationStyle = .fullScreen
        galleryVC.delegate = self
        self.present(galleryVC, animated: true, completion: nil)
        galleryVC.updateDataSourceWithNewLivePhotos()
        self.livePhotoDetailVC.updateDataSourceWithNewLivePhotos()

    }
    
    func didSelectedFindHotCagetory() {
        let galleryVC = LivePhotoGalleryViewController()
        galleryVC.modalPresentationStyle = .fullScreen
        galleryVC.delegate = self
        self.present(galleryVC, animated: true, completion: nil)
        galleryVC.updateDataSourceWithHotLivePhotos()
        self.livePhotoDetailVC.updateDataSourceWithHotLivePhotos()
    }
    
    func didSelectedCagetory(category: LivePhotoCategory, subCagetoryId: Int, subCagetoryName: String) {
        let galleryVC = LivePhotoGalleryViewController()
        galleryVC.modalPresentationStyle = .fullScreen
        galleryVC.delegate = self
        self.present(galleryVC, animated: true, completion: nil)
        galleryVC.updateDataSourcSelectedSubCategory(category: category)
        self.livePhotoDetailVC.updateDataSourcSelectedSubCategory(category: category)
    }
}

extension LPRootViewController: LivePhotoGalleryViewControllerDelegate {
    func galleryDidSelectedLivephoto(index: Int, galleryVC: LivePhotoGalleryViewController) {
        self.livePhotoDetailVC.changePageIndex(index: index)
        galleryVC.dismiss(animated: true, completion: nil)
        self.hideMenuVC()
    }
}
