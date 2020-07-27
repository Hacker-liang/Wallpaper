//
//  AdManager.swift
//  Wallpaper
//
//  Created by langren on 2020/7/24.
//  Copyright © 2020 langren. All rights reserved.
//

import UIKit

class AdManager: NSObject {
    
    private static let Banner_600x90_Id = "945348135"
    private static let Reward_Video_Id = "945348230"

    class func loadBannerAd<T: UIViewController & BUNativeExpressBannerViewDelegate>(in controller: T) -> BUNativeExpressBannerView {
        
        let bannerViewWidth = controller.view.bounds.size.width
        let bannerViewHeight = bannerViewWidth/UIScreen.main.bounds.size.width*90
        
        let bannerView = BUNativeExpressBannerView(slotID: Banner_600x90_Id, rootViewController: controller, adSize: CGSize(width: bannerViewWidth, height: bannerViewHeight), isSupportDeepLink: true)
        
        bannerView.frame = CGRect(x: 0, y: controller.view.bounds.size.height-bannerViewHeight, width: bannerViewWidth, height: bannerViewHeight)
        
        bannerView.delegate = controller
        bannerView.loadAdData()
        return bannerView
    }
    
    class func loadRewardAd<T: UIViewController & BUNativeExpressRewardedVideoAdDelegate>(in controller: T) -> BUNativeExpressRewardedVideoAd {
        
        let model = BURewardedVideoModel()
        model.userId = "123"
        let videoAd = BUNativeExpressRewardedVideoAd(slotID: Reward_Video_Id, rewardedVideoModel: model)
        
        videoAd.delegate = controller
        videoAd.loadData()
        
        return videoAd
    }
    
}
