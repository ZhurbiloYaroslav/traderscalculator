//
//  PurchasesTestVC.swift
//  TradersCalculator
//
//  Created by Yaroslav Zhurbilo on 30.07.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit
import SwiftyStoreKit
import StoreKit

var productsSharedSecret = "e78dac645bbe42f688687da5962713a4"

enum RegisteredPurchase : String {
    case BuyPro = "com.diglabstudio.TraderCalculator.BuyPro"
}

class PurchasesTestVC: UIViewController {
    
    @IBOutlet weak var appStatusLabel: UILabel!
    @IBOutlet weak var buyProButton: UIButton!
    @IBOutlet weak var restoreButton: UIButton!
    
    var appStatus: String!
    var BuyPro = RegisteredPurchase.BuyPro
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getInfo(purchase: BuyPro)
    }
    
    @IBAction func buyProButtonPressed(_ sender: UIButton) {
        purchase(purchase: BuyPro)
    }
    
    @IBAction func restoreButtonPressed(_ sender: UIButton) {
        restorePurchases()
    }
    
    func getInfo(purchase: RegisteredPurchase) {
        NetworkActivityIndicatorManager.NetworkOperationStarted()
        
        SwiftyStoreKit.retrieveProductsInfo([purchase.rawValue]) { (result) in
            
            print("Invalid products: ",result.invalidProductIDs)
            NetworkActivityIndicatorManager.NetworkOperationFinished()
            
            self.showAlert(alert: self.alertForProductRetrievalInfo(result: result))
            
        }
        
    }
    
    func purchase(purchase: RegisteredPurchase) {
        NetworkActivityIndicatorManager.NetworkOperationStarted()
        
        SwiftyStoreKit.purchaseProduct(purchase.rawValue) { (result) in
            
            NetworkActivityIndicatorManager.NetworkOperationFinished()
            
            if case .success(let product) = result {
                
                if product.productId == self.BuyPro.rawValue {
                    
                    self.appStatusLabel.text = "Purchased"
                    
                }
                
                if product.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(product.transaction)
                }
                self.showAlert(alert: self.alertForPurchaseResult(result: result))
                
            }
            
        }
        
    }
    
    func restorePurchases() {
        NetworkActivityIndicatorManager.NetworkOperationStarted()
        
        SwiftyStoreKit.restorePurchases(atomically: true) { (result) in
            NetworkActivityIndicatorManager.NetworkOperationFinished()
            
            for product in result.restoredPurchases {
                
                if product.needsFinishTransaction {
                    
                    SwiftyStoreKit.finishTransaction(product.transaction)
                    
                }
            }
            
            self.showAlert(alert: self.alertForRestorePurchases(result: result))
            
        }
        
        
    }
    
    func verifyReceipt() {
        NetworkActivityIndicatorManager.NetworkOperationStarted()
        
        let appleValidator = AppleReceiptValidator(service: .sandbox)
        SwiftyStoreKit.verifyReceipt(using: appleValidator, password: productsSharedSecret) { (result) in
            
            NetworkActivityIndicatorManager.NetworkOperationFinished()
            
            self.showAlert(alert: self.alertForVerifyReceipt(result: result))
            
            /* Here is an error
            if case .error(let error) = result {
                if case .noreceiptData = error {
                    
                    self.refreshReceipt()
                    
                }
            }
            */
            
        }
    }
    
    func verifyPurchase(product: RegisteredPurchase) {
        NetworkActivityIndicatorManager.NetworkOperationStarted()
        
        let appleValidator = AppleReceiptValidator(service: .sandbox)
        SwiftyStoreKit.verifyReceipt(using: appleValidator, password: productsSharedSecret) { (result) in
            
            NetworkActivityIndicatorManager.NetworkOperationFinished()
            
            switch result {
                
            case .success(let receipt):
                
                let productID = product.rawValue
                
                if product == .BuyPro {
                    let purchaseResult = SwiftyStoreKit.verifyPurchase(productId: productID, inReceipt: receipt)
                    self.showAlert(alert: self.alertForVerifyPurchase(result: purchaseResult))
                }
            case .error(let error):
                self.showAlert(alert: self.alertForVerifyReceipt(result: result))
                if case .noReceiptData = error {
                    self.refreshReceipt()
                }
            }
            
        }
        
    }
    
    func refreshReceipt() {
        NetworkActivityIndicatorManager.NetworkOperationStarted()
        
        let appleValidator = AppleReceiptValidator(service: .sandbox)
        SwiftyStoreKit.verifyReceipt(using: appleValidator, password: productsSharedSecret) { (result) in
            
            NetworkActivityIndicatorManager.NetworkOperationFinished()
            
            self.showAlert(alert: self.alertForRefreshReceipt(result: result))
            
        }
    }
    
    
}

extension UIViewController {
    
    func alertWithTitle(title: String, message: String) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return alert
    }
    
    func showAlert(alert: UIAlertController) {
        
        guard let _ = self.presentedViewController else {
            
            self.present(alert, animated: true, completion: nil)
            return
        }
        
    }
    
    func alertForProductRetrievalInfo(result: RetrieveResults) -> UIAlertController {
        
        if let product = result.retrievedProducts.first {
            
            let priceString = product.localizedPrice
            return alertWithTitle(title: product.localizedTitle,
                                  message: "\(product.localizedDescription) - \(String(describing: priceString))")
            
        } else if let inValidProductID = result.invalidProductIDs.first {
            
            return alertWithTitle(title: "Could not retrieve product Info",
                                  message: "Invalid product Identifier: \(inValidProductID)")
            
        } else {
            let errorString = result.error?.localizedDescription ?? "Unknown error, please contact support"
            return alertWithTitle(title: "Could not retrieve product Info", message: errorString)
        }
        
    }
    
    func alertForPurchaseResult(result: PurchaseResult) -> UIAlertController {
        
        switch result {
            
        case .success(let product):
            
            print("Purchase successful: \(product.productId)")
            return alertWithTitle(title: "Thank you", message: "Purchase completed")
            
        case .error(let error):
            
            print("There is an error: \(error)")
            
            return alertWithTitle(title: "Error", message: "There is an error: \(error)")
            
        }
        
    }
    
    func alertForRestorePurchases(result: RestoreResults) -> UIAlertController {
        
        if result.restoreFailedPurchases.count > 0 {
            
            print("Restore failed: \(result.restoreFailedPurchases)")
            return alertWithTitle(title: "Restore failed", message: "Unknown error, please contact support")
            
        } else if result.restoredPurchases.count > 0 {
            
            return alertWithTitle(title: "Purchases are restored", message: "All purchases have been restored.")
            
        } else {
            
            return alertWithTitle(title: "Nothing to restore", message: "No previous purchases were made")
            
        }
        
    }
    
    func alertForVerifyReceipt(result: VerifyReceiptResult) -> UIAlertController {
        
        switch result {
            
        case .success( _ /* receipt */):
            
            return alertWithTitle(title: "Receipt Varied", message: "Receipt Verified Remotely")
            
        case .error(let error):
            
            switch error {
            case .noReceiptData:
                return alertWithTitle(title: "Receipt Verification", message: "No receipt data found, application will try to get a new one. Try Again")
            default:
                return alertWithTitle(title: "Receipt Verification", message: "Receipt verification failed")
            }
        }
        
    }
    
    func alertForVerifyPurchase(result: VerifyPurchaseResult) -> UIAlertController {
        
        switch result {
        case .purchased:
            return alertWithTitle(title: "Product is purchased", message: "Product will not be expire")
        case .notPurchased:
            return alertWithTitle(title: "Product is not Purchased", message: "Product has never been purchased")
        }
        
    }
    
    //Here was: RefreshReceiptResult
    func alertForRefreshReceipt(result: VerifyReceiptResult) -> UIAlertController {
        
        switch result {
        case .success( _ /* receiptData */):
            return alertWithTitle(title: "Receipt Refreshed", message: "Receipt refresh successfully")
        case .error( _ /* error */):
            return alertWithTitle(title: "Receipt refresh failed", message: "Receipt refresh failed")
        }
        
    }
    
}













