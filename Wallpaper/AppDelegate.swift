//
//  AppDelegate.swift
//  LivePhoto
//
//  Created by langren on 2020/7/9.
//  Copyright © 2020 langren. All rights reserved.
//

import UIKit
import LeanCloud

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    fileprivate let LeanCloudAppId = "Rb8NeaTsBVx4PXBY4FMAskQQ-gzGzoHsz"
    fileprivate let LeanCloudAppKey = "qdRAAvwmzjXqjdMFb4gNCgvh"
    fileprivate let LeanCloudServerUrl = "http://leancloud.livephotos.5vlive.cn"

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.setupLeanCloud()
        return true
    }
}

extension AppDelegate {
    fileprivate func setupLeanCloud() {
        #if DEBUG
        LCApplication.logLevel = .error
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
}
