//
//  LivePhotoConfig.swift
//  Wallpaper
//
//  Created by langren on 2020/9/24.
//  Copyright © 2020 langren. All rights reserved.
//

import UIKit
import LeanCloud

let LeanCloud_LivePhotosConfig = "LivePhotoConfig"

class LivePhotoConfig: NSObject {
    static let shared = LivePhotoConfig()
    
    private (set) var showVideoAds = false
    
    private var new_free_limit = 100
    private var new_vip_limit = 1000
    
    private var hot_free_limit = 100
    private var hot_vip_limit = 1000
    
    private var category3d_free_limit = 100
    private var category3d_vip_limit = 1000
    
    private var categorydongtai_free_limit = 100
    private var categorydongtai_vip_limit = 1000
    
    override init() {
        super.init()
        self.updateLimiteData()
    }

    func getCategoryLimited(categoryId: Int) -> Int {
        self.updateLimiteData()
        
        if categoryId == 1 { //3d壁纸
            if LPAccount.shared.isVip {
                return category3d_vip_limit
            } else {
                return category3d_free_limit
            }
        } else if categoryId == 2 { //动态壁纸
            if LPAccount.shared.isVip {
                return categorydongtai_vip_limit
            } else {
                return categorydongtai_free_limit
            }
        }
        return 1000
    }
    
    func getHotLimited() -> Int {
        self.updateLimiteData()
        if LPAccount.shared.isVip {
            return hot_vip_limit
        } else {
            return hot_free_limit
        }
    }
    
    func getNewLimited() -> Int {
        self.updateLimiteData()
        if LPAccount.shared.isVip {
            return new_vip_limit
        } else {
            return new_free_limit
        }
    }
    
    private func updateLimiteData() {
        let query = LCQuery(className: LeanCloud_LivePhotosConfig)

        query.find { (result) in
            switch result {
            case .success(objects: let configs):
                if let config = configs.first {
                    if let number = config.get("new_free_limit") as? LCNumber, let value = number.intValue {
                        self.new_free_limit = value
                    }
                    if let number = config.get("new_vip_limit") as? LCNumber, let value = number.intValue {
                        self.new_vip_limit = value
                    }
                    if let number = config.get("hot_free_limit") as? LCNumber, let value = number.intValue {
                        self.hot_free_limit = value
                    }
                    if let number = config.get("hot_vip_limit") as? LCNumber, let value = number.intValue {
                        self.hot_vip_limit = value
                    }
                    
                    if let number = config.get("category3d_free_limit") as? LCNumber, let value = number.intValue {
                        self.category3d_free_limit = value
                    }
                    if let number = config.get("category3d_vip_limit") as? LCNumber, let value = number.intValue {
                        self.category3d_vip_limit = value
                    }
                    
                    if let number = config.get("categorydongtai_free_limit") as? LCNumber, let value = number.intValue {
                        self.categorydongtai_free_limit = value
                    }
                    if let number = config.get("categorydongtai_vip_limit") as? LCNumber, let value = number.intValue {
                        self.categorydongtai_vip_limit = value
                    }
                    
                    if let number = config.get("showVideoAds") as? LCBool {
                        self.showVideoAds = number.value
                    }
                }
                
            case .failure(error: let error):
                print(error)
                
            }
        }
    }
}

