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
        self.clipsToBounds = true
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
        
        let diamond = UIImageView()
        diamond.contentMode = .scaleAspectFill
        diamond.image = UIImage(named: "icon_vip_banner_diamond")
        addSubview(diamond)
        diamond.snp.makeConstraints { (make) in
            make.leading.equalTo(11.5)
            make.top.equalTo(2)
            make.width.equalTo(61)
            make.height.equalTo(55.5)
        }
        
        let slogan = UIImageView()
        slogan.contentMode = .scaleAspectFill
        slogan.image = UIImage(named: "icon_vip_banner_slogan")
        addSubview(slogan)
        slogan.snp.makeConstraints { (make) in
            make.centerX.equalTo(self).offset(-20)
            make.top.equalTo(15)
            make.width.equalTo(173)
            make.height.equalTo(27)
        }
        
        upgradeButton = UIButton()
        upgradeButton.setImage(UIImage(named: "icon_vip_banner_upgrade"), for: .normal)
        
        addSubview(upgradeButton)
        upgradeButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(0)
            make.width.equalTo(108)
            make.height.equalTo(39)
            make.top.equalTo(10)
        }
    }
}
