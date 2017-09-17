//
//  OptSelectParamsVC.swift
//  TradersCalculator
//
//  Created by Yaroslav Zhurbilo on 15.07.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit
import GoogleMobileAds

class OptSelectParamsVC: UIViewController {
    
    @IBOutlet weak var firstLaunchNavBar: UINavigationBar!
    @IBOutlet weak var googleBannerView: GADBannerView!
    @IBOutlet weak var currencyOrLanguageLabel: UILabel!
    @IBOutlet weak var currencyOrLanguagePickerView: UIPickerView!
    @IBOutlet weak var leverageLabel: UILabel!
    @IBOutlet weak var leveragePickerView: UIPickerView!
    @IBOutlet weak var stackViewLeverage: UIStackView!
    @IBOutlet weak var saveButtonAtFirstLaunch: UIBarButtonItem!
    
    @IBOutlet weak var containerConstraintToChange: NSLayoutConstraint!
    
    var options: UserDefaultsManager!
    var adMob: AdMob!
    
    var freeOrProVersion: FreeOrProVersion!
    
    // If we press "Choose language" in Options, this value is True
    var doWeChooseLanguageNow: Bool?
    var doWeChooseParamsAtFirstLaunch: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUILabelsWithLocalizedText()
        
        initDelegates()
        
        initializeVariables()
        
        options = UserDefaultsManager()
        
//        adMob = AdMob()
//        adMob.getLittleBannerFor(viewController: self, adBannerView: googleBannerView)
        
        selectDefaultRowsInPickerViews()
        
    }
    
    @IBAction func bannerPressed(_ sender: UIButton) {
        
        CustomBanner().showAdvertAfterBannerPressed()
        
    }
    
    func updateUILabelsWithLocalizedText() {
        
        navigationItem.title = "Parameters".localized()
        
        if doWeChooseLanguageNow == nil {
            currencyOrLanguageLabel.text = "Choose account currency".localized()
        } else {
            currencyOrLanguageLabel.text = "Choose language".localized()
        }
        
        if doWeChooseParamsAtFirstLaunch != nil {
            
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save".localized(),
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(saveButtonPressed(sender:)))
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back".localized(),
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(saveButtonPressed(sender:)))
        
        leverageLabel.text = "Choose account leverage".localized()
        
    }
    
    func initDelegates() {
        
        self.currencyOrLanguagePickerView.delegate = self
        self.leveragePickerView.delegate = self
        
    }
    
    func initializeVariables() {
        
        freeOrProVersion = FreeOrProVersion(bannerView: googleBannerView,
                                            constraint: containerConstraintToChange,
                                            tableViewToChange: nil)
        
        if doWeChooseParamsAtFirstLaunch == nil {
            firstLaunchNavBar.isHidden = true
        }
        
    }
    
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
            let accountCurrency = options.accountCurrency
            
            var accountLeverage = Constants.defaultLeverage
            if let _leverage = options.leverage {
                accountLeverage = _leverage
                doWeChooseParamsAtFirstLaunch = nil
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
    
    @IBAction func saveButtonAtFirstLaunchPressed(_ sender: UIBarButtonItem) {
        saveButtonPressed(sender: sender)
    }
    
    func saveButtonPressed(sender: UIBarButtonItem) {
        
        
        
        if doWeChooseLanguageNow != nil {
            
            let languageNumber = currencyOrLanguagePickerView.selectedRow(inComponent: 0)
            
            options.language = Constants.languages[languageNumber]
            performSegue(withIdentifier: "backToOptionsFromParametersWithSaving", sender: nil)
            
        } else {
            
            let currencyNumber = currencyOrLanguagePickerView.selectedRow(inComponent: 0)
            let leverageNumber = leveragePickerView.selectedRow(inComponent: 0)
            
            options.accountCurrency = Constants.currenciesOfAccount[currencyNumber]
            options.leverage = Constants.leverage[leverageNumber]
            
            if doWeChooseParamsAtFirstLaunch == nil {
                
                performSegue(withIdentifier: "backToOptionsFromParametersWithSaving", sender: nil)
                navigationController?.popViewController(animated: true)
                
            } else {
                
                performSegue(withIdentifier: "backToCalculatorFromParamsSelectionPage", sender: nil)
            }
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        freeOrProVersion.removeAdIfPRO()
        
        updateUILabelsWithLocalizedText()
        
    }
    
}

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
