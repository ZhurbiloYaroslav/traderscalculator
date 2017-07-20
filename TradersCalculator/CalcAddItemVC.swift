//
//  CalcAddItemVC.swift
//  TradersCalculator
//
//  Created by Yaroslav Zhurbilo on 15.07.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit
import GoogleMobileAds

class CalcAddItemVC: UIViewController {
    
    @IBOutlet weak var googleBannerView: GADBannerView!

    @IBOutlet weak var instrumentsPicker: UIPickerView!
    
    @IBOutlet weak var instrumentDescription: UILabel!
    
    var instruments: Instruments!
    var currentCategory: Int!
    var currentInstrument: Int!
    
    var test = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init delegates
        initDelegates()
        
        // adMob
        adMob()
        
        initializeVariables()
        
        
    }
    
    // Init delegates
    func initDelegates() {
        
        instrumentsPicker.delegate = self
        instrumentsPicker.dataSource = self
        
    }
    
    func initializeVariables() {
        
        instruments = Instruments()
        currentCategory = 0
        currentInstrument = 0
        
        
        getDescriptionOfInstrumentIn(instrumentsPicker)
        
    }
    
    //ADMOB
    func adMob() {
        
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        
        googleBannerView.adUnitID = "ca-app-pub-7923953444264875/5465129548"
        googleBannerView.rootViewController = self
        googleBannerView.load(request)
        
    }

}

// Data Picker Delegates and methods
extension CalcAddItemVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Explanations 1: makeapppie.com/2014/10/21/swift-swift-formatting-a-uipickerview/
    // Explanations 2: makeapppie.com/2014/10/20/swift-swift-using-attributed-strings-in-swift/
    
    
    //TODO: Write a description
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        //TODO: Write a description
        return 3
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            return instruments.categories.count
        } else if component == 1 {
            return instruments.getArrayWithInstrumentsBy(categoryID: currentCategory).count
        } else {
            return instruments.getRightCurrencyPairsArrayFor(instrumentID: currentInstrument, inCategoryID: currentCategory).count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let pickerLabel = UILabel()
        var titleData = ""
        
        if component == 0 {
            
            pickerLabel.textAlignment = .center
            
            //TODO: Write a description
            titleData = instruments.getCategoryNameBy(categoryID: row)
            
        } else if component == 1 {
            
            pickerLabel.textAlignment = .center
            
            //TODO: Write a description
            titleData = instruments.getArrayWithInstrumentsBy(categoryID: currentCategory)[row]
            
        } else {
            
            pickerLabel.textAlignment = .left
            
            //TODO: Write a description
            titleData = instruments.getRightCurrencyPairsArrayFor(instrumentID: currentInstrument, inCategoryID: currentCategory)[row]
            
        }
        
        //TODO: Remove force-unvrap
        let myTitle = NSAttributedString(string: titleData, attributes:
                                         [NSFontAttributeName:UIFont(name: "Georgia", size: 15.0)!,
                                          NSForegroundColorAttributeName:UIColor.darkGray])
        
        pickerLabel.attributedText = myTitle
        return pickerLabel
        
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        
        if component == 0 {
            
            return 120
            
        } else if component == 1 {
            
            return 90
            
        } else {
            
            return 40
            
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        if component == 0 {
            
            currentCategory = row
            currentInstrument = 0
            pickerView.reloadComponent(1)
            pickerView.reloadComponent(2)
            pickerView.selectRow(0, inComponent: 1, animated: true)
            pickerView.selectRow(0, inComponent: 2, animated: true)
            
            // Get the description of the Instrument
            getDescriptionOfInstrumentIn(pickerView)
            
        } else if component == 1 {
            
            currentInstrument = row
            print(currentInstrument)
            
            pickerView.reloadComponent(2)
            pickerView.selectRow(0, inComponent: 2, animated: true)
            
            // Get the description of the Instrument
            getDescriptionOfInstrumentIn(pickerView)
            
        } else {
            
            // Get the description of the Instrument
            getDescriptionOfInstrumentIn(pickerView)
            
        }
        
        
    }
    
    // Get the description of the Instrument
    func getDescriptionOfInstrumentIn(_ pickerView: UIPickerView) {
        
        let secondColumn = pickerView.selectedRow(inComponent: 1)
        let thirdColumn = pickerView.selectedRow(inComponent: 2)
        let instrumentFullName = instruments.getFullInstrumentNameBy(categoryID: currentCategory,
                                                                     leftPart: secondColumn,
                                                                     rightPart: thirdColumn)
        
        instrumentDescription.text = "Описание для " + instrumentFullName
        
    }
    
}









