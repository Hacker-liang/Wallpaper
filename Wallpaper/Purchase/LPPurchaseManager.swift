//
//  lPPurchaseManager.swift
//  Wallpaper
//
//  Created by langren on 2020/7/16.
//  Copyright © 2020 langren. All rights reserved.
//

import UIKit
import StoreKit

protocol LPPurchaseManagerDelegate: NSObject {
    
    func productRequestDidFinish()
    
    func productRequestOnError()
}

private class WeakTargetBox: NSObject {
    weak var target: LPPurchaseManagerDelegate?
    
    convenience init(_ target: LPPurchaseManagerDelegate) {
        self.init()
        self.target = target
    }
}

class LPPurchaseManager: NSObject {
    
    public static let shared = LPPurchaseManager()
    
    private (set) var products = [SKProduct]()
    
    private var targets = [WeakTargetBox]()
    
    /// 保存购买的交易回调
    private var purchaseCallbackQueue = [String: ((SKPaymentTransaction)->Void)]()
    
    private var restorePurchaseCallback: ((SKPaymentTransaction?)->Void)?
    
    override init() {
        super.init()
        //设置支付监听
        SKPaymentQueue.default().add(self)
    }
    
    deinit {
        //移除支付监听
        SKPaymentQueue.default().remove(self)
    }
    
    func addTarget(target: LPPurchaseManagerDelegate) {
        
        var exit = false
        self.targets.forEach { (box) in
            if let t = box.target, t == target {
                exit = true
            }
        }
        if !exit {
            self.targets.append(WeakTargetBox(target))
        }
    }
    
    func loadPurchaseItems() {
        if SKPaymentQueue.canMakePayments() {
            fetchProducts(matchingIdentifiers: ["com.5vdesign.livephotos.weekly","com.5vdesign.livephotos.monthly","com.5vdesign.livephotos.yearly"])
        } else {
            print("无法请求内购信息")
        }
    }
    
    func purchase(_ product: SKProduct, transcationCompletion:@escaping ((_ transaction: SKPaymentTransaction)->Void)) {
        
        self.purchaseCallbackQueue[product.productIdentifier] = transcationCompletion
        
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    func restorePurchase(transcationCompletion:@escaping ((_ transaction: SKPaymentTransaction?)->Void)) {
        self.restorePurchaseCallback = transcationCompletion
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    fileprivate func fetchProducts(matchingIdentifiers identifiers: [String]) {
        let productIdentifiers = Set(identifiers)
        let productRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productRequest.delegate = self
        productRequest.start()
    }
}

extension LPPurchaseManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.products.removeAll()
        self.products.append(contentsOf: response.products.sorted(by: {$0.price.intValue < $1.price.intValue}))
        
        print("didReceive\(response)")
    }
    
    func requestDidFinish(_ request: SKRequest) {
        print("requestDidFinish\(request)")
        DispatchQueue.main.async {
            self.targets.forEach { (box) in
                box.target?.productRequestDidFinish()
            }
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("didFailWithError \(error)")
        self.products.removeAll()
        DispatchQueue.main.async {
            self.targets.forEach { (box) in
                box.target?.productRequestOnError()
            }
        }
    }
}

extension LPPurchaseManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            if transaction.transactionState == .purchased {
                SKPaymentQueue.default().finishTransaction(transaction)
                print("购买成功")
                
            } else if transaction.transactionState == .failed {
                SKPaymentQueue.default().finishTransaction(transaction)
                print("购买失败")

            } else if transaction.transactionState == .purchasing {
                print("正在购买")
                
            } else if transaction.transactionState == .restored {
                print("恢复购买成功")
                SKPaymentQueue.default().finishTransaction(transaction)
            }
        }
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        if let callback = restorePurchaseCallback {
            callback(queue.transactions.first)
        }
        print("paymentQueueRestoreCompletedTransactionsFinished")
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        print("restoreCompletedTransactionsFailedWithError error:\(error)")
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
        print("paymentQueue removedTransactions \(transactions)")
    }
}
