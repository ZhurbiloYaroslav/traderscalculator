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
    
    var options: UserDefaultsManager!
    
    var productIdBuyPro = "com.diglabstudio.TraderCalculator.BuyPro"
    var purchases: [SKProduct]!
    var p: SKProduct!
    
    @IBOutlet weak var currencyCell: UITableViewCell!
    @IBOutlet weak var leverageCell: UITableViewCell!
    @IBOutlet weak var languageCell: UITableViewCell!
    @IBOutlet weak var buyProCell: UITableViewCell!
    @IBOutlet weak var restorePurchasesCell: UITableViewCell!
    @IBOutlet weak var appInfoCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUILabelsWithLocalizedText()
        
        initializeVariables()
        
        updateTable()
        
    }
    
    func updateUILabelsWithLocalizedText() {
        
        currencyCell.textLabel?.text = "Account currency".localized()
        leverageCell.textLabel?.text = "Leverage".localized()
        languageCell.textLabel?.text = "Language".localized()
        buyProCell.textLabel?.text = UserDefaultsManager().isProVersion ? "Pro version".localized() : "Buy Pro".localized()
        restorePurchasesCell.textLabel?.text = "Restore purchases".localized()
        appInfoCell.textLabel?.text = "Developers".localized()
    }
    
    func initializeVariables() {
        
        options = UserDefaultsManager()
        
        purchases = [SKProduct]()
        p = SKProduct()
        
        makePurchaseAndRestoreButtons(state: .Disabled)
        
        requestProUpgradeProductData()
        
    }
    
    func requestProUpgradeProductData() {
        
        if (SKPaymentQueue.canMakePayments()) {
            
            let productsID: NSSet = NSSet(objects: productIdBuyPro)
            let request: SKProductsRequest = SKProductsRequest(productIdentifiers: productsID as! Set<String>)
            request.delegate = self
            request.start()
            
        } else {
            
            // "Please, enable IAP"
        }
        
    }
    
    // Update the Table View
    func updateTable() {
        
        currencyCell.detailTextLabel?.text = options.accountCurrency
        leverageCell.detailTextLabel?.text = options.leverage
        languageCell.detailTextLabel?.text = options.language
        
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
                if(prodID == productIdBuyPro) {
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
    
    func switchPro() {
        if let parentVC = self.parent as? OptionsVC {
            parentVC.removeAdIfPRO()
        }
    }
    
    //TODO: Unwind segue from Picker Views with selecting
    @IBAction func backToOptionsFromParametersWithSaving(sender: UIStoryboardSegue) {
        updateTable()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Account parameters".localized()
        case 1:
            return "Interfaсe".localized()
        case 2:
            return "Purchases".localized()
        case 3:
            return "App info".localized()
        default:
            return "".localized()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateUILabelsWithLocalizedText()
        
    }
    
}

//MARK: Methods That related to Store Kit
extension OptionsTableVC: SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        let myProducts = response.products
        
        for product in myProducts {
            
            purchases.append(product)
            
        }
        
        makePurchaseAndRestoreButtons(state: .Enabled)
        
    }
    
    func makePurchaseAndRestoreButtons(state: ButtonState) {
        
        var isEnabled = true
        
        if state == .Disabled {
            isEnabled = false
        }
        
        buyProCell.isUserInteractionEnabled = isEnabled
        restorePurchasesCell.isUserInteractionEnabled = isEnabled
        
    }
    
    enum ButtonState {
        case Enabled
        case Disabled
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        
        for transaction in queue.transactions {
            let t: SKPaymentTransaction = transaction
            let productID = t.payment.productIdentifier
            
            switch productID {
            case productIdBuyPro:
                
                purchaseProVersion()
                
            default:
                print("IAP not found")
            }
        }
    }
    
    func makeThisAppPro() {
        
        if UserDefaultsManager().isProVersion {
            buyProCell.textLabel?.text = "Pro version".localized()
            
            switchPro()
        }
        
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction: AnyObject in transactions {
            
            if let trans = transaction as? SKPaymentTransaction {
                
                switch trans.transactionState {
                case .purchased:
                    
                    switch p.productIdentifier {
                    case productIdBuyPro:
                        
                        purchaseProVersion()
                        
                    default:
                        break
                        // "IAP not found"
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
    
    func recordTransaction(_ transaction: SKPaymentTransaction) {
        
        if transaction.payment.productIdentifier == productIdBuyPro {
            
            //TODO: Save transaction receipt to the User Defaults
            
            UserDefaultsManager().isProVersion = true
            
        }
        
    }
    
    func enableProFunctions() {
        
        if UserDefaultsManager().isProVersion {
            
        }
        
    }
    
    // This function purchases PRO version
    func purchaseProVersion() {
        
        let payment = SKPayment(product: p)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(payment as SKPayment)
        
    }
    
}

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


