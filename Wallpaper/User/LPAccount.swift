//
//  LPAccount.swift
//  Wallpaper
//
//  Created by langren on 2020/7/27.
//  Copyright © 2020 langren. All rights reserved.
//

import UIKit

let kVipStatusChangedNoti = "kVipStatusChangedNoti"

class LPAccount: NSObject {
    
    let vipExpiredDateCacheKey = "vipExpiredDateCacheKey"
    
    static let shared = LPAccount()
    
    private (set) var isVip: Bool = false {
        didSet {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kVipStatusChangedNoti), object: nil)
            }
        }
        
    }
    
    private var isWorking = false
    
    public func userDidLogin() {
        if let expiredTime = UserDefaults.standard.object(forKey: self.vipExpiredDateCacheKey) as? Int {
            self.isVip = expiredTime > Int(Date().timeIntervalSince1970)
        }
        self.updateVipStatus()
    }
    
    public func forceUpadateVipSatus(isVip: Bool) {
        
        self.isVip = isVip
        UserDefaults.standard.set(Int(NSDate().timeIntervalSince1970+24*3600), forKey: self.vipExpiredDateCacheKey)

        self.updateVipStatus(callback: nil)
    }
    
    public func updateVipStatus(callback:((_ isVip: Bool)->Void)? = nil) {
        
        IAP.validateReceipt(Constants.IAPSharedSecret) { (statusCode, products, json) in
            if statusCode == ReceiptStatus.noRecipt.rawValue {
                self.isVip = false
                UserDefaults.standard.set(0, forKey: self.vipExpiredDateCacheKey)
                
            } else {
                let list = products?.sorted(by: { (p1, p2) -> Bool in
                    return p1.1.timeIntervalSince1970 > p2.1.timeIntervalSince1970
                })
                if list?.first?.1.timeIntervalSince1970 ?? 0 <= Date().timeIntervalSince1970 {
                    self.isVip = false
                    UserDefaults.standard.set(0, forKey: self.vipExpiredDateCacheKey)
                } else {
                    self.isVip = true
                    UserDefaults.standard.set(Int(list?.first?.1.timeIntervalSince1970 ?? 0), forKey: self.vipExpiredDateCacheKey)
                }
            }
            DispatchQueue.main.async {
                callback?(self.isVip)
            }
            
            OperationQueue.main.addOperation({
                self.isWorking = false
            })
        }
    }
}
