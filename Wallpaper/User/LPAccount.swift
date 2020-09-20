//
//  LPAccount.swift
//  Wallpaper
//
//  Created by langren on 2020/7/27.
//  Copyright © 2020 langren. All rights reserved.
//

import UIKit

class LPAccount: NSObject {
    
    let vipExpiredDateCacheKey = "vipExpiredDateCacheKey"
    
    static let shared = LPAccount()
    
    private (set) var isVip: Bool = false
    
    
    public func userDidLogin() {
        
        if let vipDate = UserDefaults.standard.object(forKey: vipExpiredDateCacheKey) as? Int, vipDate>Int(NSDate().timeIntervalSince1970) {
            self.isVip = true
        } else {
            self.isVip = false
        }
        LPPurchaseManager.shared.restorePurchase { (success) in
            if success {
                self.isVip = true
            } else {
                self.isVip = false
            }
        }
    }
    
    public func updateVipStatus(isVip: Bool, expiredData: Int) {
        self.isVip = isVip
        UserDefaults.standard.set(isVip ? expiredData:0, forKey: vipExpiredDateCacheKey)
    }
}
