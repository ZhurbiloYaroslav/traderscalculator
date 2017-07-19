//
//  CalcAddItemVC.swift
//  TradersCalculator
//
//  Created by Yaroslav Zhurbilo on 15.07.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit

class CalcAddItemVC: UIViewController {

    @IBOutlet weak var instrumentsPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init delegates
        initDelegates()
        
        
        Instruments().getDictionaryWithInstruments()
    }
    
    // Init delegates
    func initDelegates() {
        
        instrumentsPicker.delegate = self
        instrumentsPicker.dataSource = self
        
    }

}

// Data Picker Delegates and methods
extension CalcAddItemVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Explanations 1: makeapppie.com/2014/10/21/swift-swift-formatting-a-uipickerview/
    // Explanations 2: makeapppie.com/2014/10/20/swift-swift-using-attributed-strings-in-swift/
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            return 5
        } else if component == 1 {
            return 5
        } else {
            return 5
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let pickerLabel = UILabel()
        var titleData = ""
        
//        var testDictionary = [
//            "Forex Majors": [],
//            "Forex Minors": [],
//            "Forex Exotics": []]
//        ]
        
        
        if component == 0 {
            
            pickerLabel.textAlignment = .center
            titleData = "Forex"
            
        } else if component == 1 {
            
            pickerLabel.textAlignment = .center
            titleData = "USD"
            
        } else {
            
            pickerLabel.textAlignment = .left
            titleData = "EUR"
            
        }
        
        //TODO: Remove force-unvrap
        let myTitle = NSAttributedString(string: titleData, attributes:
                                         [NSFontAttributeName:UIFont(name: "Georgia", size: 20.0)!,
                                          NSForegroundColorAttributeName:UIColor.darkGray])
        
        pickerLabel.attributedText = myTitle
        return pickerLabel
        
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        //TODO: Write here something
        
    }
    
//    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
//        
//        //TODO: Write here something
//        
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
//        
//        //TODO: Write here something
//        
//    }
    
}







