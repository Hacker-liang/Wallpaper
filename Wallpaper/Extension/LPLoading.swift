//
//  LPLoading.swift
//  Wallpaper
//
//  Created by langren on 2020/9/22.
//  Copyright © 2020 langren. All rights reserved.
//

import UIKit

extension UIView {
    
    fileprivate static let loadingViewTag = 10000001
    
    func showLoading() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        imageView.tag = UIView.loadingViewTag
        imageView.center = CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.height/2)
        
        self.subviews.forEach { (view) in
            if view.tag == UIView.loadingViewTag {
                view.removeFromSuperview()
            }
        }
        self.addSubview(imageView)
        var images = [UIImage]()
        for i in 0...29 {
            let image = UIImage(named: "200w_000\(i)")
            images.append(image!)
        }
        imageView.animationImages = images
        imageView.animationRepeatCount = 0
        imageView.animationDuration = 1.0
        imageView.startAnimating()
    }
    
    func hideLoading() {
        self.subviews.forEach { (view) in
            if view.tag == UIView.loadingViewTag {
                (view as? UIImageView)?.stopAnimating()
                view.removeFromSuperview()
            }
        }
    }
}
