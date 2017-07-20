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
    @IBOutlet weak var currencyPickerView: UIPickerView!
    @IBOutlet weak var leveragePickerView: UIPickerView!
    
    var firebase: FirebaseConnect!  // Reference variable for the Database
    var adMob: AdMob!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init delegates
        initDelegates()
        
        // Configure the Firebase
        firebase = FirebaseConnect()
        
        // adMob
        adMob = AdMob()
        adMob.getLittleBannerFor(viewController: self, andBannerView: googleBannerView)
        
        // Select Default rows in Picker Views
        selectDefaultRowsInPickerViews()
        
    }
    
    // Init delegates
    func initDelegates() {
        
        self.currencyPickerView.delegate = self
        self.leveragePickerView.delegate = self
        
    }
    
    // Select Default rows in Picker Views
    func selectDefaultRowsInPickerViews() {
        
        // Select rows in PickerView
        if currencyPickerView.numberOfRows(inComponent: 0) > 2 {
            currencyPickerView.selectRow(1, inComponent: 0, animated: true)
        }
        if leveragePickerView.numberOfRows(inComponent: 0) > 2 {
            leveragePickerView.selectRow(3, inComponent: 0, animated: true)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Remove Firebase Authenticate listener
        if let tempHandle = firebase.handle {
            Auth.auth().removeStateDidChangeListener(tempHandle)
        }
        
    }

}

// Place for PickerView Delegates and methods
extension OptSelectParamsVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView.tag == 1 {
            // It means that the picker is Currency
            
            return Constants.currenciesOfAccount.count
            
        } else {
            // It means that the picker is Leverage
            
            return Constants.leverage.count
        }
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView.tag == 1 {
            // It means that the picker is Currency
            
            return Constants.currenciesOfAccount[row]
            
        } else {
            // It means that the picker is Leverage
            
            return Constants.leverage[row]
        }
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        //TODO: write here
        
    }
    
}
