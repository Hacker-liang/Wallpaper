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
    
    var purchaseManager: LPPurchaseManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        purchaseManager = LPPurchaseManager()
        purchaseManager.delegate = self
        productTableView.dataSource = self
        productTableView.delegate = self
        purchaseManager.loadPurchaseItems()
    }

    @IBAction func puchaseButtonAction(_ sender: Any) {
        purchaseManager.restorePurchase { (transaction) in
            
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
        return purchaseManager.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(purchaseManager.products[indexPath.row].localizedTitle)"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}


extension LPPurchaseViewController: LPPurchaseManagerDelegate {
    
    func productRequestDidFinish() {
        self.productTableView.reloadData()
    }
    
    func productRequestOnError() {
        self.productTableView.reloadData()
    }
    
}
