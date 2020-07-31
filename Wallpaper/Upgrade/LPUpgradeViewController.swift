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
    
    @IBOutlet weak var tableView: UITableView!
    
    var currentSelectedIndex: Int = -1
    
    var dataSource: [SKProduct] {
        get {
            return LPPurchaseManager.shared.products
        }
    }
    
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
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "LPProductTableViewCell", bundle: nil), forCellReuseIdentifier: "LPProductTableViewCell")
        tableView.rowHeight = 40.0
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .clear
        tableView.separatorColor = .clear
        LPPurchaseManager.shared.loadPurchaseItems()
    }
    
    @IBAction func puchaseButtonAction(_ sender: Any) {
        guard self.dataSource.count > currentSelectedIndex && currentSelectedIndex >= 0 else {
            return
        }
        LPPurchaseManager.shared.purchase(self.dataSource[currentSelectedIndex]) { (transaction) in
            
        }
    }
    
    @IBAction func restoreButtonAction(_ sender: Any) {
        LPPurchaseManager.shared.restorePurchase { (transaction) in
            
        }
    }
    
    @IBAction func gobackAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension LPUpgradeViewController: LPPurchaseManagerDelegate {
    
    func productRequestDidFinish() {
        if self.dataSource.count > 0 {
            currentSelectedIndex = 0
        }
       
        self.tableView.reloadData()
    }
    
    func productRequestOnError() {
        currentSelectedIndex = -1
        self.tableView.reloadData()
    }
    
}

extension LPUpgradeViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row ==  self.dataSource.count - 1 {
            return 41.0
        } else {
            return 56.0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LPProductTableViewCell", for: indexPath) as! LPProductTableViewCell
        let product = self.dataSource[indexPath.row]
        cell.titleLabel?.text = "\(product.localizedTitle)"
        if #available(iOS 12.2, *) {
            if product.discounts.count > 0 {
                cell.descLabel.text = "3天免费试用可自动续订"
            } else {
                cell.descLabel.text = nil
            }
        } else {
            cell.descLabel.text = nil
        }
        cell.isSelected = indexPath.row == currentSelectedIndex
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentSelectedIndex = indexPath.row
    }
}

