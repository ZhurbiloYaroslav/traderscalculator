//
//  OptSelectParamsVC.swift
//  TradersCalculator
//
//  Created by Yaroslav Zhurbilo on 15.07.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit
import GoogleMobileAds
import FirebaseDatabase
import FirebaseAuth

class OptSelectParamsVC: UIViewController {
    
    @IBOutlet weak var firstLaunchNavBar: UINavigationBar!
    @IBOutlet weak var googleBannerView: GADBannerView!
    @IBOutlet weak var currencyOrLanguageLabel: UILabel!
    @IBOutlet weak var currencyOrLanguagePickerView: UIPickerView!
    @IBOutlet weak var leveragePickerView: UIPickerView!
    @IBOutlet weak var stackViewLeverage: UIStackView!
    
    var firebase: FirebaseConnect!  // Reference variable for the Database
    var options: UserDefaultsManager!
    var adMob: AdMob!
    
    // If we press "Choose language" in Options, this value is True
    var doWeChooseLanguageNow: Bool?
    var doWeChooseParamsAtFirstLaunch: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init delegates
        initDelegates()
        
        initializeVariables()
        
        // User Options from User defaults
        options = UserDefaultsManager()
        
        // Configure the Firebase
        firebase = FirebaseConnect()
        
        // adMob
        adMob = AdMob()
        adMob.getLittleBannerFor(viewController: self, adBannerView: googleBannerView)
        
        // Select Default rows in Picker Views
        selectDefaultRowsInPickerViews()
        
    }
    
    // Init delegates
    func initDelegates() {
        
        self.currencyOrLanguagePickerView.delegate = self
        self.leveragePickerView.delegate = self
        
    }
    
    func initializeVariables() {
        
        //TODO: Write comment
        if doWeChooseParamsAtFirstLaunch == nil {
            firstLaunchNavBar.isHidden = true
        }
        
    }
    
    // Select Default rows in Picker Views
    func selectDefaultRowsInPickerViews() {
        
        if doWeChooseLanguageNow != nil {
            // Means, that we choose now language
            stackViewLeverage.isHidden = true
            currencyOrLanguageLabel.text = "Choose language".localized()
            
            if let currentLanguageIndex = Constants.languages.index(of: options.language) {
                currencyOrLanguagePickerView.selectRow(currentLanguageIndex, inComponent: 0, animated: true)
            }
            
        } else {
            // Means, that we choose now currency and leverage
            
            doWeChooseParamsAtFirstLaunch = true
            var accountCurrency = Constants.defaultCurrency
            if let _accountCurrency = options.accountCurrency {
                accountCurrency = _accountCurrency
                doWeChooseParamsAtFirstLaunch = false
            }
            
            var accountLeverage = Constants.defaultLeverage
            if let _leverage = options.leverage {
                accountLeverage = _leverage
                doWeChooseParamsAtFirstLaunch = false
            }
            
            // Select rows in PickerView
            if let currentCurrencyIndex = Constants.currenciesOfAccount.index(of: accountCurrency) {
                currencyOrLanguagePickerView.selectRow(currentCurrencyIndex, inComponent: 0, animated: true)
            }
            
            if let currentLeverageIndex = Constants.leverage.index(of: accountLeverage) {
                leveragePickerView.selectRow(currentLeverageIndex, inComponent: 0, animated: true)
            }
        }
        
    }

    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
                
        if doWeChooseLanguageNow != nil {
            
            let languageNumber = currencyOrLanguagePickerView.selectedRow(inComponent: 0)
            
            options.language = Constants.currenciesOfAccount[languageNumber]
            
        } else {
            
            let currencyNumber = currencyOrLanguagePickerView.selectedRow(inComponent: 0)
            let leverageNumber = leveragePickerView.selectedRow(inComponent: 0)
            
            options.accountCurrency = Constants.currenciesOfAccount[currencyNumber]
            options.leverage = Constants.leverage[leverageNumber]
            
            if doWeChooseParamsAtFirstLaunch == nil {
                
                navigationController?.popViewController(animated: true)
                performSegue(withIdentifier: "backToCalculatorFromParamsSelectionPage", sender: nil)
                
            } else {
                
                performSegue(withIdentifier: "backToCalculatorFromParamsSelectionPage", sender: nil)
                
            }
            
        }
        
    }
    
}

// Place for PickerView Delegates and methods
extension OptSelectParamsVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if doWeChooseLanguageNow != nil {
            if pickerView.tag == 1 {
                // It means that the picker is Language
                
                return Constants.languages.count
                
            } else {
                // It means that the picker is Leverage
                
                return 0
            }
        } else {
            
            if pickerView.tag == 1 {
                // It means that the picker is Currency
                
                return Constants.currenciesOfAccount.count
                
            } else {
                // It means that the picker is Leverage
                
                return Constants.leverage.count
            }
            
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if doWeChooseLanguageNow != nil {
            
            if pickerView.tag == 1 {
                // It means that the picker is Language
                
                return Constants.languages[row]
                
            } else {
                // It means that the picker is Leverage
                
                return Constants.leverage[row]
            }
            
        } else {
            
            if pickerView.tag == 1 {
                // It means that the picker is Currency
                
                return Constants.currenciesOfAccount[row]
                
            } else {
                // It means that the picker is Leverage
                
                return Constants.leverage[row]
            }
            
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if doWeChooseLanguageNow != nil {
            
            if pickerView.tag == 1 {
                // It means that the picker is Language
                
                options.language = Constants.languages[row]
                
            } else {
                // It means that the picker is Leverage
                
                options.leverage = Constants.leverage[row]
            }
            
        } else {
            
            if pickerView.tag == 1 {
                // It means that the picker is Currency
                
                options.accountCurrency = Constants.currenciesOfAccount[row]
                
            } else {
                // It means that the picker is Leverage
                
                options.leverage = Constants.leverage[row]
            }
            
        }
        
        
    }
    
}
