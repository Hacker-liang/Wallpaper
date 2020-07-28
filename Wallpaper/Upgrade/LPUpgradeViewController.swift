//
//  LPUpgradeViewController.swift
//  Wallpaper
//
//  Created by langren on 2020/7/16.
//  Copyright © 2020 langren. All rights reserved.
//

import UIKit
import StoreKit

class LPUpgradeViewController: UIViewController {
    
    @IBOutlet weak var purchaseButton: UIButton!
    
    @IBOutlet weak var restoreButton: UIButton!
    
    var currentSelectedIndex: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LPPurchaseManager.shared.addTarget(target: self)
        LPPurchaseManager.shared.loadPurchaseItems()
        restoreButton.layer.cornerRadius = 18.5
        restoreButton.layer.borderColor = UIColor.rgb(0x9A90A1).cgColor
        restoreButton.layer.borderWidth = 1.0
        
        purchaseButton.layer.cornerRadius = 29.5
        purchaseButton.layer.masksToBounds = true
        let layer = CAGradientLayer()
        layer.frame = purchaseButton.bounds
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 0)
        layer.colors = [UIColor.rgb(0xDE5E97).cgColor, UIColor.rgb(0xD2310C).cgColor]
        purchaseButton.layer.insertSublayer(layer, at: 0)
        
    }
    
    @IBAction func puchaseButtonAction(_ sender: Any) {
        let advanceVC = LPAdvanceViewController()
        advanceVC.modalPresentationStyle = .fullScreen
        self.present(advanceVC, animated: false, completion: nil)
    }
    
    @IBAction func restoreButtonAction(_ sender: Any) {
    }
    
    @IBAction func gobackAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension LPUpgradeViewController: LPPurchaseManagerDelegate {
    
    func productRequestDidFinish() {
        currentSelectedIndex = -1
    }
    
    func productRequestOnError() {
        currentSelectedIndex = -1
    }
    
}
