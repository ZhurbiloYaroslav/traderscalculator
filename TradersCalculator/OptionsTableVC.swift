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
    
    var userDefaultsManager: UserDefaultsManager!
    
    var products = [SKProduct]()
    
    @IBOutlet weak var currencyCell: UITableViewCell!
    @IBOutlet weak var leverageCell: UITableViewCell!
    @IBOutlet weak var languageCell: UITableViewCell!
    @IBOutlet weak var buyProCell: UITableViewCell!
    @IBOutlet weak var restorePurchasesCell: UITableViewCell!
    @IBOutlet weak var appInfoCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeVariables()
        
        updateUILabels()
        
        updateTable()
        
        setNObserverToHandlePurchaseNotification()
        
    }
    
    func initializeVariables() {
        
        userDefaultsManager = UserDefaultsManager()
        
    }
    
    func updateUILabels() {
        
        currencyCell.textLabel?.text = "Account currency".localized()
        leverageCell.textLabel?.text = "Leverage".localized()
        languageCell.textLabel?.text = "Language".localized()
        restorePurchasesCell.textLabel?.text = "Restore purchases".localized()
        appInfoCell.textLabel?.text = "Developers".localized()
        
        let isProVersion = userDefaultsManager.isProVersion
        buyProCell.textLabel?.text = isProVersion ? "Pro version".localized() : "Buy Pro".localized()
        restorePurchasesCell.isHidden = isProVersion ? true : false
    }
    
    func setNObserverToHandlePurchaseNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(OptionsTableVC.handlePurchaseNotification(_:)),
                                               name: NSNotification.Name(rawValue: IAPHelper.IAPHelperPurchaseNotification),
                                               object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        reload()
    }
    
    func reload() {
        products = []
        
        self.updateTable()
        
        AppProducts.store.requestProducts{success, products in
            
            if success {
                self.products = products!
                
                self.updateTable()
            }
            
        }
    }
    
    func handlePurchaseNotification(_ notification: Notification) {
        guard let productID = notification.object as? String else { return }
        
        for product in products {
            guard product.productIdentifier == productID else {
                continue
            }
            
            self.enableProFunctions()
        }
    }
    
    func updateTable() {
        
        if userDefaultsManager.isProVersion {
            makePurchaseAndRestoreButtons(state: .Disabled)
        }
        
        currencyCell.detailTextLabel?.text = userDefaultsManager.accountCurrency
        leverageCell.detailTextLabel?.text = userDefaultsManager.leverage
        languageCell.detailTextLabel?.text = userDefaultsManager.language
        
        tableView.reloadData()
        
        updateUILabels()
        
    }
    
    func switchPro() {
        
        if let parentVC = self.parent as? OptionsVC {
            
            parentVC.removeAdIfPRO()
            restorePurchasesCell.isHidden = true
            
        }
    }
    
    func enableProFunctions() {
        
        buyProCell.textLabel?.text = "Pro version".localized()
        
        if userDefaultsManager.isProVersion {
            
            self.switchPro()
            self.updateTable()
            
        }
        
    }
    
    //TODO: Unwind segue from Picker Views with selecting
    @IBAction func backToOptionsFromParametersWithSaving(sender: UIStoryboardSegue) {
        updateTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateUILabels()
        
    }
    
}

extension OptionsTableVC {
    
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath {
        case [0,0]:
            
            performSegue(withIdentifier: "OptionsChangeLeverage", sender: nil)
            
        case [0,1]:
            
            performSegue(withIdentifier: "OptionsChangeLeverage", sender: nil)
            
        case [1,0]:
            
            performSegue(withIdentifier: "OptionsChangeLanguage", sender: nil)
            
        case [2,0]:
            
            for product in products {
                let prodID = product.productIdentifier
                if(prodID == AppProducts.BuyProProductID) {
                    
                    AppProducts.store.buyProduct(product)
                }
            }
            
        case [2,1]:
            
            AppProducts.store.restorePurchases()
            
        default:
            break
        }
        
    }
    
}

//MARK: Methods That related to Store Kit
extension OptionsTableVC: SKPaymentTransactionObserver {
    
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
            case AppProducts.BuyProProductID:
                
                enableProFunctions()
                
            default:
                print("IAP not found")
            }
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction: AnyObject in transactions {
            
            if let trans = transaction as? SKPaymentTransaction {
                
                switch trans.transactionState {
                case .purchased:
                    
                    switch products[0].productIdentifier {
                    case AppProducts.BuyProProductID:
                        
                        enableProFunctions()
                        
                    default:
                        break
                        // "IAP not found"
                    }
                    
                    // Finish currecn transaction
                    queue.finishTransaction(trans)
                case .failed:
                    
                    print("Buy error")
                    // Finish current transaction
                    queue.finishTransaction(trans)
                    break
                default:
                    print("Default")
                    break
                }
            }
            
        }
    }
    
}

extension OptionsTableVC {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueIdentifier = segue.identifier
            else { return }
        guard let destination = segue.destination as? OptSelectParamsVC
            else { return }
        
        switch segueIdentifier {
        case "OptionsChangeLanguage":
            destination.doWeChooseLanguageNow = true
            
        case "OptionsChangeLeverage":
            destination.doWeChooseParamsAtFirstLaunch = nil
            
        case "OptionsChangeAccountCurrency":
            destination.doWeChooseParamsAtFirstLaunch = nil
            
        default:
            break
        }
    }
    
}


