//
//  CalcAddItemVC.swift
//  TradersCalculator
//
//  Created by Yaroslav Zhurbilo on 15.07.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit

import GoogleMobileAds
import FirebaseDatabase
import FirebaseAuth

class CalcAddItemVC: UIViewController {
    
    //TODO: shrikar.com/xcode-6-tutorial-grouped-uitableview/
    
    @IBOutlet weak var viewInScrollView: UIView!
    @IBOutlet weak var googleBannerView: GADBannerView!
    @IBOutlet weak var instrumentsPicker: UIPickerView!
    @IBOutlet weak var instrumentDescription: UILabel!
    @IBOutlet weak var positionValue: UITextField!
    @IBOutlet weak var positionOpenPrice: UITextField!
    @IBOutlet weak var positionTakeProfit: UITextField!
    @IBOutlet weak var positionStopLoss: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var firebase: FirebaseConnect!  // Reference variable for the Database
    var adMob: AdMob!
    var forexAPI: ForexAPI!
    
    var instruments: Instruments!
    var currentCategoryID: Int!
    var currentInstrumentID: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init delegates
        initDelegates()
        
        // Configure the Firebase
        firebase = FirebaseConnect()
        
        // adMob
        adMob = AdMob()
        adMob.getLittleBannerFor(viewController: self, adBannerView: googleBannerView)
        
        initializeVariables()
        
        // Make request to the server
        makeRequest()
        
        registerForKeyboardNotifications()
        
    }
    
    // Init delegates
    func initDelegates() {
        
        instrumentsPicker.delegate = self
        instrumentsPicker.dataSource = self
        
        
        positionValue.delegate = self
        positionOpenPrice.delegate = self
        positionTakeProfit.delegate = self
        positionStopLoss.delegate = self
        
    }
    
    func initializeVariables() {
        
        instruments = Instruments()
        currentCategoryID = 0
        currentInstrumentID = 0
        
        navigationItem.backBarButtonItem?.title = ""
        
        getDescriptionOfInstrumentIn(instrumentsPicker)
        
    }
    
    // Make request to the server
    func makeRequest() {
        
        forexAPI = ForexAPI()
        forexAPI.downloadInstrumentsRates {
            self.updateUI()
        }
        
    }
    
    func updateUI() {
        
        let currentInstrumentName = getInstrumentName(instrumentsPicker)
        if let currentInstrumentRates = forexAPI.ratesByInstrumentName[currentInstrumentName]?["rate"] {
            positionOpenPrice.text = currentInstrumentRates
            positionStopLoss.text = currentInstrumentRates
            positionTakeProfit.text = currentInstrumentRates
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Remove Firebase Authenticate listener
        if let tempHandle = firebase.handle {
            Auth.auth().removeStateDidChangeListener(tempHandle)
        }
        
    }

    deinit {
        removeKeyboardNotifications()
    }
    
    @IBAction func sellOrBuyButtonPressed(_ sender: UIButton) {
        
        if sender.tag == 0 {
            // Was pressed Sell button
            
            // Get the dictionary with values from text fields
            guard let positionValuesDict = makeDictionaryWithFieldsValues(dealDirection: "Sell")
                else { return }
            // Add new owner
            firebase.ref.child("positions").childByAutoId().setValue(positionValuesDict)
            
        } else {
            // Was pressed Buy button
            
            // Get the dictionary with values from text fields
            guard let positionValuesDict = makeDictionaryWithFieldsValues(dealDirection: "Buy")
                else { return }
            
            // Add new owner
            firebase.ref.child("positions").childByAutoId().setValue(positionValuesDict)
            
        }
        
        // Dismiss this view controller and go to previous
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        positionValue.resignFirstResponder()
        positionOpenPrice.resignFirstResponder()
        positionTakeProfit.resignFirstResponder()
        positionStopLoss.resignFirstResponder()
        
        return true
    }
    
}

// Textfield Delegate
extension CalcAddItemVC: UITextFieldDelegate {
    
}

// Methods, that helps hide Keyboard
extension CalcAddItemVC {
    
    //TODO: Hide keyboard
    func registerForKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
    }
    
    func removeKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    func keyboardWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo
        guard let keyboardFrameSize = (userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            else { return }
        scrollView.contentOffset = CGPoint(x: 0, y: keyboardFrameSize.height)
    }
    
    func keyboardWillHide() {
        scrollView.contentOffset = CGPoint.zero
    }
    
}

// Methods that related with Firebase
extension CalcAddItemVC {
    
    //TODO: Make a description
    func makeDictionaryWithFieldsValues(dealDirection: String) -> Dictionary<String, Any>? {
        
        //TODO: Make a check to have a correct results
        guard let value = positionValue.text else { return nil }
        guard let openPrice = positionOpenPrice.text else { return nil }
        guard let stopLoss = positionStopLoss.text else { return nil }
        guard let takeProfit = positionTakeProfit.text else { return nil }
        
        // Make a adictionary with values for inserting to Firebase
        let positionDict = [
            "instrument": getInstrumentName(instrumentsPicker),
            "category": instruments.getCategoryNameBy(categoryID: currentCategoryID),
            "value": value,
            "openPrice": openPrice,
            "takeProfit": takeProfit,
            "stopLoss": stopLoss,
            "creationDate": "20.07.2017",
            "dealDirection": dealDirection
        ]
        
        return positionDict
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
            return instruments.getArrayWithInstrumentsBy(categoryID: currentCategoryID).count
        } else {
            return instruments.getRightCurrencyPairsArrayFor(instrumentID: currentInstrumentID, inCategoryID: currentCategoryID).count
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
            titleData = instruments.getArrayWithInstrumentsBy(categoryID: currentCategoryID)[row]
            
        } else {
            
            pickerLabel.textAlignment = .left
            
            //TODO: Write a description
            titleData = instruments.getRightCurrencyPairsArrayFor(instrumentID: currentInstrumentID, inCategoryID: currentCategoryID)[row]
            
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
            
            currentCategoryID = row
            currentInstrumentID = 0
            pickerView.reloadComponent(1)
            pickerView.reloadComponent(2)
            pickerView.selectRow(0, inComponent: 1, animated: true)
            pickerView.selectRow(0, inComponent: 2, animated: true)
            
            // Get the description of the Instrument
            getDescriptionOfInstrumentIn(pickerView)
            updateUI()
            
        } else if component == 1 {
            
            currentInstrumentID = row
            
            pickerView.reloadComponent(2)
            pickerView.selectRow(0, inComponent: 2, animated: true)
            
            // Get the description of the Instrument
            getDescriptionOfInstrumentIn(pickerView)
            updateUI()
            
        } else {
            
            // Get the description of the Instrument
            getDescriptionOfInstrumentIn(pickerView)
            updateUI()
            
        }
        
        
    }
    
    // Get Name of the Instrument
    func getInstrumentName(_ pickerView: UIPickerView) -> String {
        
        let secondColumn = pickerView.selectedRow(inComponent: 1)
        let thirdColumn = pickerView.selectedRow(inComponent: 2)
        let instrumentFullName = instruments.getFullInstrumentNameBy(categoryID: currentCategoryID,
                                                                     leftPart: secondColumn,
                                                                     rightPart: thirdColumn)
        
        return instrumentFullName
    }
    
    // Get the description of the Instrument
    func getDescriptionOfInstrumentIn(_ pickerView: UIPickerView) {
        
        let instrumentFullName = getInstrumentName(pickerView)
        
        instrumentDescription.text = "Description for " + instrumentFullName
        
    }
    
}









