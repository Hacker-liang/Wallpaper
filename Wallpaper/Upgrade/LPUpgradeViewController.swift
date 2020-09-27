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
    
    @IBOutlet weak var flashImageView: UIImageView!
    var currentSelectedIndex: Int = -1
    
    var dataSource: [SKProduct] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        IAP.requestProducts(["com.5vdesign.livephotos.weekly","com.5vdesign.livephotos.monthly","com.5vdesign.livephotos.yearly"]) {[weak self] (response, error) in
            if let products = response?.products {
                DispatchQueue.main.async {
                    self?.dataSource = products.sorted { (i, j) -> Bool in
                        i.price.doubleValue < j.price.doubleValue
                    }
                    
                    self?.tableView.reloadData()
                }
            }
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "LPProductTableViewCell", bundle: nil), forCellReuseIdentifier: "LPProductTableViewCell")
        tableView.rowHeight = 40.0
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .clear
        tableView.separatorColor = .clear
        if dataSource.count > 0 {
            currentSelectedIndex = 0
        }
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.startAnimation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NSObject.cancelPreviousPerformRequests(withTarget: self)
    }
    
    
    @objc private func startAnimation() {
        var images = [UIImage]()
        for i in 1...5 {
            let image = UIImage(named: "upgrade_image_\(i)")
            images.append(image!)
        }
        flashImageView.animationImages = images
        flashImageView.animationRepeatCount = 1
        flashImageView.animationDuration = 7.5
        flashImageView.startAnimating()
        flashImageView.image = images.last
        
        self.perform(#selector(startAnimation), with: nil, afterDelay: 5.0)
    }
    
    private func goAdvancedCtl() {
        
        let ctl = LPAdvanceViewController()
        ctl.willMove(toParent: self)
        self.addChild(ctl)
        ctl.view.frame = self.view.bounds
        self.view.addSubview(ctl.view)
    }
    
    @IBAction func puchaseButtonAction(_ sender: Any) {
        guard self.dataSource.count > currentSelectedIndex && currentSelectedIndex >= 0 else {
            return
        }
        let hud = JGProgressHUD()
        hud.show(in: self.view)
        
        IAP.purchaseProduct(self.dataSource[currentSelectedIndex].productIdentifier) {[weak self] (identifier, error) in
            DispatchQueue.main.async {
                hud.dismiss(animated: true)
                if error == nil {
                    LPAccount.shared.forceUpadateVipSatus(isVip: true)
                    UIApplication.shared.keyWindow!.makeToast("购买成功", duration: 1, position: CSToastPositionCenter)
                    self?.goAdvancedCtl()
                } else {
                    UIApplication.shared.keyWindow!.makeToast("购买失败", duration: 1, position: CSToastPositionCenter)

                }
            }
            
        }
        
    }
    
    @IBAction func restoreButtonAction(_ sender: Any) {
        let hud = JGProgressHUD()
        hud.show(in: self.view)
        LPAccount.shared.updateVipStatus {[weak self] (isVip) in
    
            hud.dismiss(animated: true)
            guard let weakSelf = self else {
                return
            }
            if isVip {
                UIApplication.shared.keyWindow!.makeToast("恢复成功", duration: 1, position: CSToastPositionCenter)
                weakSelf.goAdvancedCtl()
            } else {
                UIApplication.shared.keyWindow!.makeToast("恢复失败", duration: 1, position: CSToastPositionCenter)
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

