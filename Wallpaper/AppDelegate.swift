//
//  AppDelegate.swift
//  LivePhoto
//
//  Created by langren on 2020/7/9.
//  Copyright © 2020 langren. All rights reserved.
//

import UIKit
import LeanCloud
import StoreKit

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    fileprivate let LeanCloudAppId = "Rb8NeaTsBVx4PXBY4FMAskQQ-gzGzoHsz"
    fileprivate let LeanCloudAppKey = "qdRAAvwmzjXqjdMFb4gNCgvh"
    fileprivate let LeanCloudServerUrl = "http://leancloud.livephotos.5vlive.cn"

    fileprivate let BUAd_AppId = "5091389"

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.setupLeanCloud()
        self.setupBUAd()
        LPAccount.shared.userDidLogin()
        IAP.requestProducts(["com.5vdesign.livephotos.weekly","com.5vdesign.livephotos.monthly","com.5vdesign.livephotos.yearly"]) { (response, error) in
            
        }
        
        self.showRatingIfNeeded()
        
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+3) {
//            LivePhotoNetworkHelper.uploadLivePhoto()
//
//        }
//        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return true
    }
    
    private func showRatingIfNeeded() {
        let launchCountKey = "lauchCount"
        let limitCount = 10
        if let count = UserDefaults.standard.object(forKey: launchCountKey) as? Int {
            if count <= 0 {
                SKStoreReviewController.requestReview()
                UserDefaults.standard.set(limitCount, forKey: launchCountKey)

            } else {
                UserDefaults.standard.set(count-1, forKey: launchCountKey)
            }
        } else {
            UserDefaults.standard.set(limitCount, forKey: launchCountKey)
        }
        
    }
}

extension AppDelegate {
    fileprivate func setupLeanCloud() {
        #if DEBUG
        LCApplication.logLevel = .all
        #endif
        do {
            try LCApplication.default.set(
                id: LeanCloudAppId,
                key: LeanCloudAppKey,
                serverURL: LeanCloudServerUrl)
        } catch {
            print(error)
        }
    }
    
    fileprivate func setupBUAd() {
        BUAdSDKManager.setAppID(BUAd_AppId)
        BUAdSDKManager.setIsPaidApp(false)
        #if DEBUG
        BUAdSDKManager.setLoglevel(.debug)
        #endif
    }
}

