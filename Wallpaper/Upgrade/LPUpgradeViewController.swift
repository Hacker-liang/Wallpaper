//
//  LPUpgradeViewController.swift
//  Wallpaper
//
//  Created by langren on 2020/7/16.
//  Copyright © 2020 langren. All rights reserved.
//

import UIKit
import StoreKit
import JGProgressHUD

class LPUpgradeViewController: UIViewController {
    
    @IBOutlet weak var purchaseButton: UIButton!
    
    @IBOutlet weak var restoreButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    var currentSelectedIndex: Int = -1
    
    var dataSource: [SKProduct] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = LPPurchaseManager.shared.products
        
        LPPurchaseManager.shared.loadPurchaseItems { [weak self] (products) in
            self?.dataSource = products
            self?.tableView.reloadData()
        }
       
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "LPProductTableViewCell", bundle: nil), forCellReuseIdentifier: "LPProductTableViewCell")
        tableView.rowHeight = 40.0
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .clear
        tableView.separatorColor = .clear
        dataSource =  LPPurchaseManager.shared.products
        if dataSource.count > 0 {
            currentSelectedIndex = 0
        }
        tableView.reloadData()

    }
    
    private func goAdvancedCtl() {
        
        let ctl = LPAdvanceViewController()
        ctl.willMove(toParent: self)
        self.addChild(ctl)
        self.view.addSubview(ctl.view)
    }
    
    @IBAction func puchaseButtonAction(_ sender: Any) {
        guard self.dataSource.count > currentSelectedIndex && currentSelectedIndex >= 0 else {
            return
        }
        let hud = JGProgressHUD()
        hud.show(in: self.view)
        LPPurchaseManager.shared.purchase(self.dataSource[currentSelectedIndex]) {[weak self] (success) in
            hud.dismiss(animated: true)
            guard let weakSelf = self else {
                return
            }
            if success {
                
               UIApplication.shared.keyWindow!.makeToast("购买成功", duration: 1, position: CSToastPositionCenter)
                
                let product: SKProduct = weakSelf.dataSource[weakSelf.currentSelectedIndex]
                
                if #available(iOS 11.2, *) {
                    if let period = product.subscriptionPeriod {
                        
                        var distance: Int = 0
                        if period.unit == .day {
                            distance = period.numberOfUnits * 3600*24
                        } else if period.unit == .week {
                            distance = period.numberOfUnits * 7*3600*24
                        } else if period.unit == .month {
                            distance = period.numberOfUnits * 30*3600*24
                        } else if period.unit == .year {
                            distance = period.numberOfUnits * 365*3600*24
                        }
                        LPAccount.shared.updateVipStatus(isVip: true, expiredData: Int(Date().timeIntervalSince1970)+distance)
                    }
                } else {
                    LPAccount.shared.updateVipStatus(isVip: true, expiredData: 0)

                }
                weakSelf.goAdvancedCtl()


            } else {
                UIApplication.shared.keyWindow!.makeToast("购买失败", duration: 1, position: CSToastPositionCenter)
            }
        }
    }
    
    @IBAction func restoreButtonAction(_ sender: Any) {
        let hud = JGProgressHUD()
        hud.show(in: self.view)
        LPPurchaseManager.shared.restorePurchase { [weak self] (success) in
            hud.dismiss(animated: true)
            guard let weakSelf = self else {
                return
            }
            if success {
                UIApplication.shared.keyWindow!.makeToast("恢复成功", duration: 1, position: CSToastPositionCenter)
                LPAccount.shared.updateVipStatus(isVip: true, expiredData: Int(Date().timeIntervalSince1970+3600*24))
                weakSelf.goAdvancedCtl()
            } else {
                UIApplication.shared.keyWindow!.makeToast("恢复失败", duration: 1, position: CSToastPositionCenter)
                LPAccount.shared.updateVipStatus(isVip: false, expiredData: 0)
            }
        }
    }
    
    
    @IBAction func gobackAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func privacyAction(_ sender: Any) {
        let ctl = LivePhotoPrivacyContentViewController()
        ctl.modalPresentationStyle = .fullScreen
        self.present(ctl, animated: true) {
        }
        ctl.contentTextView.text = ctl.privacyContent()

    }
    
    @IBAction func useGuidlineAction(_ sender: Any) {
        let ctl = LivePhotoPrivacyContentViewController()
        ctl.modalPresentationStyle = .fullScreen
        self.present(ctl, animated: true) {
        }
        ctl.contentTextView.text = ctl.guidlineContent()
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
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
        if #available(iOS 11.2, *) {
            print("product\(product.subscriptionPeriod?.unit.rawValue) \(product.subscriptionPeriod?.numberOfUnits)")
        }
        cell.userSelected(indexPath.row == currentSelectedIndex)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentSelectedIndex = indexPath.row
        self.tableView.reloadData()
    }
}

