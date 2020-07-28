//
//  LPVipBannerView.swift
//  Wallpaper
//
//  Created by langren on 2020/7/27.
//  Copyright © 2020 langren. All rights reserved.
//

import UIKit

class LPBuyVipBannerView: UIView {

    public var purchaseButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupContentView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupContentView() {
        let bgImageView = UIImageView()
        addSubview(bgImageView)
        bgImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        purchaseButton = UIButton()
        purchaseButton.layer.cornerRadius = 14.5
        purchaseButton.setTitle("现在升级", for: .normal)
        purchaseButton.setTitleColor(.white, for: .normal)
        purchaseButton.backgroundColor = UIColor.red
        purchaseButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
        addSubview(purchaseButton)
        purchaseButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.width.equalTo(167.5)
            make.height.equalTo(29)
            make.bottom.equalTo(14.5)
        }
    }
}
