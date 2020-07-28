//
//  LPUpgradeBannerView.swift
//  Wallpaper
//
//  Created by langren on 2020/7/27.
//  Copyright © 2020 langren. All rights reserved.
//

import UIKit

class LPUpgradeBannerView: UIView {
    
    public var upgradeButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupContentView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupContentView() {
        let bgImageView = UIImageView()
        bgImageView.contentMode = .scaleAspectFill
        bgImageView.image = UIImage(named: "icon_vip_banner_bg")
        addSubview(bgImageView)
        bgImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        let cornerView = UIImageView()
        cornerView.contentMode = .scaleAspectFill
        cornerView.image = UIImage(named: "icon_vip_banner_corner")
        addSubview(cornerView)
        cornerView.snp.makeConstraints { (make) in
            make.bottom.equalTo(-16)
            make.trailing.equalTo(-20)
            make.width.equalTo(22.5)
            make.height.equalTo(17)
        }
        
        let cornerTextView = UIImageView()
        cornerTextView.contentMode = .scaleAspectFill
        cornerTextView.image = UIImage(named: "icon_vip_banner_corner_text")
        addSubview(cornerTextView)
        cornerTextView.snp.makeConstraints { (make) in
            make.bottom.equalTo(-4.5)
            make.trailing.equalTo(-7)
            make.width.equalTo(55)
            make.height.equalTo(8)
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
        
        upgradeButton = UIButton()
        upgradeButton.layer.cornerRadius = 14.5
        upgradeButton.layer.masksToBounds = true
        upgradeButton.setTitle("现在升级", for: .normal)
        upgradeButton.setTitleColor(.white, for: .normal)
        upgradeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
        
        addSubview(upgradeButton)
        upgradeButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.width.equalTo(167.5)
            make.height.equalTo(29)
            make.bottom.equalTo(-14.5)
        }
        self.layoutIfNeeded()
        
        let layer = CAGradientLayer()
        layer.frame = upgradeButton.bounds
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 0)
        layer.colors = [UIColor.rgb(0xDE5E97).cgColor, UIColor.rgb(0xD2310C).cgColor]
        upgradeButton.layer.insertSublayer(layer, at: 0)
    }
}
