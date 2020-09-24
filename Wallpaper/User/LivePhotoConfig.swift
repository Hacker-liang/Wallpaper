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
    
    private var freeCategoryLimitedCount = 100
    private var vipCategoryLimitedCount = 1000

    func getCategoryLimited() -> Int {
        self.updateLimiteData()
        if LPAccount.shared.isVip {
            return vipCategoryLimitedCount
        } else {
            return freeCategoryLimitedCount
        }
    }
    
    private func updateLimiteData() {
        let query = LCQuery(className: LeanCloud_LivePhotosConfig)

        query.find { (result) in
            switch result {
            case .success(objects: let configs):
                if let config = configs.first {
                    if let number = config.get("free_category_count") as? LCNumber, let value = number.intValue {
                        self.freeCategoryLimitedCount = value
                    }
                    if let number = config.get("vip_category_count") as? LCNumber, let value = number.intValue {
                        self.vipCategoryLimitedCount = value
                    }
                }
                
            case .failure(error: let error):
                print(error)
                
            }
        }
    }
}

