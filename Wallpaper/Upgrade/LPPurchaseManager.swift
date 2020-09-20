//
//  lPPurchaseManager.swift
//  Wallpaper
//
//  Created by langren on 2020/7/16.
//  Copyright © 2020 langren. All rights reserved.
//

import UIKit
import StoreKit

class LPPurchaseManager: NSObject {
    
    public static let shared = LPPurchaseManager()
    
    private (set) var products = [SKProduct]()
    
    private var purchaseCallback: ((Bool)->Void)?

    private var restorePurchaseCallback: ((Bool)->Void)?
    
    private var loadPurchaseItemsCallback: (([SKProduct])->Void)?
    
    override init() {
        super.init()
        //设置支付监听
        SKPaymentQueue.default().add(self)
    }
    
    deinit {
        //移除支付监听
        SKPaymentQueue.default().remove(self)
    }
    
    func loadPurchaseItems(_ callback: @escaping ([SKProduct])->Void) {
        if SKPaymentQueue.canMakePayments() {
            fetchProducts(matchingIdentifiers: ["com.5vdesign.livephotos.weekly","com.5vdesign.livephotos.monthly","com.5vdesign.livephotos.yearly"])
            loadPurchaseItemsCallback = callback
        } else {
            print("ipa_无法请求内购信息")
            callback([])
        }
    }
    
    func purchase(_ product: SKProduct, transcationCompletion:@escaping ((_ success: Bool)->Void)) {
        if SKPaymentQueue.canMakePayments() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
            self.purchaseCallback = transcationCompletion
        } else {
            transcationCompletion(false)
            print("ipa_购买失败")
        }
    }
    
    func restorePurchase(transcationCompletion:@escaping ((_ success: Bool)->Void)) {
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
        
        print("ipa_didReceive\(response)")
    }
    
    func requestDidFinish(_ request: SKRequest) {
        print("ipa_requestDidFinish\(request)")
        DispatchQueue.main.async {
            if let callback = self.loadPurchaseItemsCallback {
                callback(self.products)
            }
            self.loadPurchaseItemsCallback = nil
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("ipa_didFailWithError \(error)")
        self.products.removeAll()
        DispatchQueue.main.async {
            if let callback = self.loadPurchaseItemsCallback {
                callback(self.products)
            }
            self.loadPurchaseItemsCallback = nil
        }
    }
}

extension LPPurchaseManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            if transaction.transactionState == .purchased {
                SKPaymentQueue.default().finishTransaction(transaction)
                if let callback = self.purchaseCallback {
                    callback(true)
                }
                print("ipa_购买成功")
                
            } else if transaction.transactionState == .failed {
                SKPaymentQueue.default().finishTransaction(transaction)
                print("ipa_购买失败")
                if let callback = self.purchaseCallback {
                    callback(false)
                }

            } else if transaction.transactionState == .purchasing {
                print("ipa_正在购买")
                
            } else if transaction.transactionState == .restored {
                print("ipa_恢复购买成功")
                SKPaymentQueue.default().finishTransaction(transaction)
            }
        }
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        DispatchQueue.main.async {
            if let callback = self.restorePurchaseCallback {
                if let transaction = queue.transactions.first, transaction.transactionState == .restored {
                    callback(true)
                } else {
                    callback(false)
                }
            }
            self.restorePurchaseCallback = nil
            print("ipa_paymentQueueRestoreCompletedTransactionsFinished")
        }
        
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        print("ipa_restoreCompletedTransactionsFailedWithError error:\(error)")
        DispatchQueue.main.async {
            if let callback = self.restorePurchaseCallback {
                callback(false)
            }
            self.restorePurchaseCallback = nil
        }
        
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
        print("ipa_paymentQueue removedTransactions \(transactions)")
    }
}
