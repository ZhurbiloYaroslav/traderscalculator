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
    
    @IBOutlet weak var googleBannerView: GADBannerView!
    @IBOutlet weak var currencyOrLanguageLabel: UILabel!
    @IBOutlet weak var currencyOrLanguagePickerView: UIPickerView!
    @IBOutlet weak var leveragePickerView: UIPickerView!
    @IBOutlet weak var stackViewLeverage: UIStackView!
    
    var firebase: FirebaseConnect!  // Reference variable for the Database
    var currentUserOptions: CurrentUser!
    var adMob: AdMob!
    
    // If we press "Choose language" in Options, this value is True
    var doWeChooseLanguageNow: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init delegates
        initDelegates()
        
        // User Options from User defaults
        currentUserOptions = CurrentUser()
        
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
    
    // Select Default rows in Picker Views
    func selectDefaultRowsInPickerViews() {
        
        if doWeChooseLanguageNow != nil {
            // Means, that we choose now language
            stackViewLeverage.isHidden = true
            currencyOrLanguageLabel.text = "Выберите язык"
            
            if let currentLanguageIndex = Constants.languages.index(of: currentUserOptions.language) {
                currencyOrLanguagePickerView.selectRow(currentLanguageIndex, inComponent: 0, animated: true)
            }
            
        } else {
            // Means, that we choose now currency and leverage
            
            // Select rows in PickerView
            if let currentCurrencyIndex = Constants.currenciesOfAccount.index(of: currentUserOptions.accountCurrency) {
                currencyOrLanguagePickerView.selectRow(currentCurrencyIndex, inComponent: 0, animated: true)
            }
            
            if let currentLeverageIndex = Constants.leverage.index(of: currentUserOptions.leverage) {
                leveragePickerView.selectRow(currentLeverageIndex, inComponent: 0, animated: true)
            }
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Remove Firebase Authenticate listener
        if let tempHandle = firebase.handle {
            Auth.auth().removeStateDidChangeListener(tempHandle)
        }
        
    }

    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        
        if doWeChooseLanguageNow != nil {
            
            let languageNumber = currencyOrLanguagePickerView.selectedRow(inComponent: 0)
            
            currentUserOptions.language = Constants.currenciesOfAccount[languageNumber]
            
        } else {
            
            let currencyNumber = currencyOrLanguagePickerView.selectedRow(inComponent: 0)
            let leverageNumber = leveragePickerView.selectedRow(inComponent: 0)
            
            currentUserOptions.accountCurrency = Constants.currenciesOfAccount[currencyNumber]
            currentUserOptions.leverage = Constants.leverage[leverageNumber]
            
        }
        
        
        
        navigationController?.popViewController(animated: true)
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
                
                currentUserOptions.language = Constants.languages[row]
                
            } else {
                // It means that the picker is Leverage
                
                currentUserOptions.leverage = Constants.leverage[row]
            }
            
        } else {
            
            if pickerView.tag == 1 {
                // It means that the picker is Currency
                
                currentUserOptions.accountCurrency = Constants.currenciesOfAccount[row]
                
            } else {
                // It means that the picker is Leverage
                
                currentUserOptions.leverage = Constants.leverage[row]
            }
            
        }
        
        
    }
    
}
