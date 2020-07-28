//
//  LPBuyVipBannerView.swift
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
        
        let tipsLabel = UILabel()
        tipsLabel.text = "解锁高级功能 定时更新 下载所有壁纸 无广告干扰"
        tipsLabel.textAlignment = .center
        tipsLabel.textColor = .white
        tipsLabel.font = UIFont.systemFont(ofSize: 13.0)
        tipsLabel.layer.cornerRadius = 4.0
        tipsLabel.layer.borderColor = UIColor.white.withAlphaComponent(0.35).cgColor
        tipsLabel.layer.borderWidth = 1.0
        addSubview(tipsLabel)
        tipsLabel.snp.makeConstraints { (make) in
            make.width.equalTo(302)
            make.height.equalTo(25)
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(13)
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
            make.bottom.equalTo(-14.5)
        }
    }
}
