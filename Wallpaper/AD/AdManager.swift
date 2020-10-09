//
//  AdManager.swift
//  Wallpaper
//
//  Created by langren on 2020/7/24.
//  Copyright © 2020 langren. All rights reserved.
//

import UIKit
import AppTrackingTransparency
import AdSupport

class AdManager: NSObject {
    
    private static let Banner_600x90_Id = "945348135"
    private static let Reward_Video_Id = "945348230"
    private static let FullScreen_Video_Id = "945348715"

    class func loadBannerAd<T: UIViewController & BUNativeExpressBannerViewDelegate>(in controller: T) -> BUNativeExpressBannerView {
        
        let bannerViewWidth = controller.view.bounds.size.width-40
        let bannerViewHeight = (bannerViewWidth/UIScreen.main.bounds.size.width)*60
        
        let bannerView = BUNativeExpressBannerView.init(slotID: Banner_600x90_Id, rootViewController: controller, adSize: CGSize(width: bannerViewWidth, height: bannerViewHeight))
//        let bannerView = BUNativeExpressBannerView(slotID: Banner_600x90_Id, rootViewController: controller, adSize: CGSize(width: bannerViewWidth, height: bannerViewHeight), isSupportDeepLink: true)
        
        bannerView.frame = CGRect(x: 20, y: (IS_IPHONE_X ? 50:30), width: bannerViewWidth, height: bannerViewHeight)
        bannerView.delegate = controller
        bannerView.loadAdData()
        return bannerView
    }
    
    class func loadRewardAd<T: UIViewController & BUNativeExpressRewardedVideoAdDelegate>(in controller: T) -> BUNativeExpressRewardedVideoAd {
        
        let model = BURewardedVideoModel()
        model.userId = "123"
        let videoAd = BUNativeExpressRewardedVideoAd(slotID: Reward_Video_Id, rewardedVideoModel: model)
        
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                videoAd.delegate = controller
                videoAd.loadData()
            })
        } else {
            videoAd.delegate = controller
            videoAd.loadData()
            // Fallback on earlier versions
        }

        return videoAd
    }
    
    class func loadFullVideoAd<T: UIViewController & BUNativeExpressFullscreenVideoAdDelegate>(in controller: T) -> BUNativeExpressFullscreenVideoAd {
        let ad = BUNativeExpressFullscreenVideoAd(slotID: FullScreen_Video_Id)

        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                ad.delegate = controller
                ad.loadData()
            })
        } else {
            ad.delegate = controller
            ad.loadData()
            // Fallback on earlier versions
        }
        return ad

    }
    
}
