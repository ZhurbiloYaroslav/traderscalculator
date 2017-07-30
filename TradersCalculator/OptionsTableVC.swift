//
//  OptionsTableVC.swift
//  TradersCalculator
//
//  Created by Yaroslav Zhurbilo on 22.07.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit
import StoreKit

class OptionsTableVC: UITableViewController {
    
    var currentUserOptions: CurrentUser!
    
    //MARK: Variables for purchases
    var purchases: [SKProduct]!
    var p: SKProduct!
    
    @IBOutlet weak var currencyCell: UITableViewCell!
    @IBOutlet weak var leverageCell: UITableViewCell!
    @IBOutlet weak var languageCell: UITableViewCell!
    @IBOutlet weak var buyProCell: UITableViewCell!
    @IBOutlet weak var restorePurchasesCell: UITableViewCell!
    @IBOutlet weak var benefitsCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init delegates
        initDelegates()
        
        initializeVariables()
        
        
        // User Options from User defaults
        currentUserOptions = CurrentUser()
        
        // Update current Table
        updateTable()
        
    }
    
    // Init delegates
    func initDelegates() {
        
        
        
    }
    
    func initializeVariables() {
        
        purchases = [SKProduct]()
        p = SKProduct()
        
        // Prepare Purchases cells before get information about purchases
        buyProCell.isUserInteractionEnabled = false
        restorePurchasesCell.isUserInteractionEnabled = false
        benefitsCell.isUserInteractionEnabled = false
        
        if (SKPaymentQueue.canMakePayments()) {
            
            print("IAP is enabled, loading")
            
            let productsID: NSSet = NSSet(objects: "com.soft4status.TradersCalculator.BuyPro")
                
            let request: SKProductsRequest = SKProductsRequest(productIdentifiers: productsID as! Set<String>)
            request.delegate = self
            request.start()
            
        } else {
            print("Please, enable IAP")
        }
        
    }
    
    // Update the Table View
    func updateTable() {
        
        currencyCell.detailTextLabel?.text = currentUserOptions.accountCurrency
        leverageCell.detailTextLabel?.text = currentUserOptions.leverage
        languageCell.detailTextLabel?.text = currentUserOptions.language
        
        tableView.reloadData()
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath {
        case [1,0]:
            // Here we make a Segue for changing the language of the App
            
            performSegue(withIdentifier: "OptionsChangeLanguage", sender: nil)
            
        case [2,0]:
        // Here we will implement Purchase of Pro version without Ads
        
        for product in purchases {
            let prodID = product.productIdentifier
            if(prodID == "com.soft4status.TradersCalculator.BuyPro") {
                p = product
                purchaseProVersion()
            }
        }
            
        case [2,1]:
            // Here we will implement Restore of Pro version without Ads
            
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().restoreCompletedTransactions()
            
        default:
            break
        }
        
    }
    
    //TODO: Unwind segue from Picker Views with selecting
    @IBAction func backToOptionsFromParametersWithSaving(sender: UIStoryboardSegue) {
        updateTable()
    }
    
    
    //TODO: github.com/Ftkey/LTModalViewController
    //TODO: cocoapods.org/pods/JModalController
    //TODO: github.com/martinnormark/HalfModalPresentationController
    
    
}

//MARK: Methods That related to Store Kit
extension OptionsTableVC: SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    // First Video: Swift 3 In App Purchase Tutorial https://www.youtube.com/watch?v=zRrs7O5yjKI
    
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        let myProducts = response.products
        print("Products from response", response.products)
        print("Invalid Products from response", response.invalidProductIdentifiers)
        
        for product in myProducts {
            print("Product added")
            print(product.productIdentifier)
            print(product.localizedTitle)
            print(product.localizedDescription)
            print(product.price)
            
            purchases.append(product)
            
        }
        
        // Enable user interactions buttons to work with Purchases
        buyProCell.isUserInteractionEnabled = true
        restorePurchasesCell.isUserInteractionEnabled = true
        benefitsCell.isUserInteractionEnabled = true
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        print("Transactions restored")
        
        for transaction in queue.transactions {
            let t: SKPaymentTransaction = transaction
            let productID = t.payment.productIdentifier
            
            switch productID {
            case "com.soft4status.TradersCalculator.BuyPro":
                
                print("Purchase PRO version")
                purchaseProVersion()
                
            default:
                print("IAP not found")
            }
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        print("Add payment")
        
        for transaction: AnyObject in transactions {
            
            if let trans = transaction as? SKPaymentTransaction {
                print(trans.error ?? "Error")
                
                switch trans.transactionState {
                case .purchased:
                    
                    print("Buy OK! Unlock IAP Here!")
                    print(p.productIdentifier)
                    //TODO: Unlock In-App purchase here!
                    
                    switch p.productIdentifier {
                    case "com.soft4status.TradersCalculator.BuyPro":
                        
                        print("Purchase PRO version")
                        purchaseProVersion()
                        
                    default:
                        print("IAP not found")
                    }
                    
                    // Finish currecn transaction
                    queue.finishTransaction(trans)
                case .failed:
                    
                    print("Buy error")
                    // Finish currecn transaction
                    queue.finishTransaction(trans)
                    break
                default:
                    print("Default")
                    break
                }
            }
            
            
        }
    }
    
    // This function purchases PRO version
    func purchaseProVersion() {
        print("Buy " + p.productIdentifier)
        let payment = SKPayment(product: p)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(payment as SKPayment)
        
    }
    
}

//MARK: Methods that related to seagues
extension OptionsTableVC {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueIdentifier = segue.identifier
            else { return }
        
        switch segueIdentifier {
        case "OptionsChangeLanguage":
            guard let destination = segue.destination as? OptSelectParamsVC
                else { return }
            destination.doWeChooseLanguageNow = true
        default:
            break
        }
    }
    
}


