//
//  LPPurchaseViewController.swift
//  Wallpaper
//
//  Created by langren on 2020/7/16.
//  Copyright © 2020 langren. All rights reserved.
//

import UIKit
import StoreKit

class LPPurchaseViewController: UIViewController {

    @IBOutlet weak var productTableView: UITableView!
    @IBOutlet weak var purchaseButton: UIButton!
    
    var currentSelectedIndex: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LPPurchaseManager.shared.addTarget(target: self)
        
        productTableView.dataSource = self
        productTableView.delegate = self
        LPPurchaseManager.shared.loadPurchaseItems()
    }

    @IBAction func puchaseButtonAction(_ sender: Any) {
        guard currentSelectedIndex >= 0 && currentSelectedIndex < LPPurchaseManager.shared.products.count else {
            return
        }
        LPPurchaseManager.shared.purchase(LPPurchaseManager.shared.products[currentSelectedIndex]) { (transaction) in
            
        }
    }
    
    @IBAction func gobackAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension LPPurchaseViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LPPurchaseManager.shared.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(LPPurchaseManager.shared.products[indexPath.row].localizedTitle)"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentSelectedIndex = indexPath.row
    }
}


extension LPPurchaseViewController: LPPurchaseManagerDelegate {
    
    func productRequestDidFinish() {
        self.productTableView.reloadData()
        currentSelectedIndex = -1
    }
    
    func productRequestOnError() {
        self.productTableView.reloadData()
        currentSelectedIndex = -1
    }
    
}
