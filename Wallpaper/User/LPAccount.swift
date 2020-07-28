//
//  LPAccount.swift
//  Wallpaper
//
//  Created by langren on 2020/7/27.
//  Copyright © 2020 langren. All rights reserved.
//

import UIKit

class LPAccount: NSObject {
    
    static let shared = LPAccount()
    
    private (set) var isVip: Bool = false
    
    public func userDidLogin() {
        LPPurchaseManager().restorePurchase { (transaction) in
            print("恢复内购的状态：\(transaction?.transactionState)")
        }
    }

}
