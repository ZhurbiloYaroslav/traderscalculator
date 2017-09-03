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
    
    @IBOutlet weak var navigationBarTitle: UILabel!
    @IBOutlet weak var viewInScrollView: UIView!
    @IBOutlet weak var googleBannerView: GADBannerView!
    @IBOutlet weak var instrumentsPicker: UIPickerView!
    @IBOutlet weak var instrumentDescription: UILabel!
    @IBOutlet weak var positionValue: UITextField!
    @IBOutlet weak var positionOpenPrice: UITextField!
    @IBOutlet weak var positionTakeProfit: UITextField!
    @IBOutlet weak var positionStopLoss: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackWithInstrumentPicker: UIStackView!
    
    var options: UserDefaultsManager!
    var firebase: FirebaseConnect!  // Reference variable for the Database
    var adMob: AdMob!
    var forexAPI: ForexAPI!
    
    var coreDataManager = CoreDataManager()
    var instruments = Instruments()
    var currentCategoryID: Int!
    var currentInstrumentLeftPartID: Int!
    var currentInstrumentRightPartID: Int!
    
    // Contains position ID in Firebase and appear when edit position from CalculatorVC
    var positionToEdit: Position?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init delegates
        initDelegates()
        
        // User Options from User defaults
        options = UserDefaultsManager()
        
        // Configure the Firebase
        firebase = FirebaseConnect()
        
        // Make request to the server
        makeRequest()
        
        // adMob
        adMob = AdMob()
        adMob.getLittleBannerFor(viewController: self, adBannerView: googleBannerView)
        
        initializeVariables()
        
        registerForKeyboardNotifications()
        
    }
    
    func initDelegates() {
        
        instrumentsPicker.delegate = self
        instrumentsPicker.dataSource = self
        
        positionValue.delegate = self
        positionOpenPrice.delegate = self
        positionTakeProfit.delegate = self
        positionStopLoss.delegate = self
        
    }
    
    func initializeVariables() {
        
        
        let lastUsedInstrument = options.lastUsedInstrument
        currentCategoryID = lastUsedInstrument.categoryID
        currentInstrumentLeftPartID = lastUsedInstrument.instrumentLeftPartID
        currentInstrumentRightPartID = lastUsedInstrument.instrumentRightPartID
        
        // Picker View
        instrumentsPicker.selectRow(currentCategoryID, inComponent: 0, animated: true)
        instrumentsPicker.selectRow(currentInstrumentLeftPartID, inComponent: 1, animated: true)
        instrumentsPicker.selectRow(currentInstrumentRightPartID, inComponent: 2, animated: true)
        
        getDescriptionOfInstrument()
        
        if let position = positionToEdit {
            navigationBarTitle.text = "Edit position"
            
            let formatString = "%.\(position.instrument.digitsAfterDot)f"
            
            stackWithInstrumentPicker.isHidden = true
            positionValue.text = String(format: "%.2f", position.value)
            positionOpenPrice.text = String(format: formatString, position.openPrice)
            positionTakeProfit.text = String(format: formatString, position.takeProfit)
            positionStopLoss.text = String(format: formatString, position.stopLoss)
            
        }
        
    }
    
    func makeRequest() {
        
        // If this is not editing of the position, then we download the data
        if positionToEdit == nil {
            
            forexAPI = ForexAPI()
            forexAPI.downloadInstrumentsRates {
                self.updateUI(snapshotData: nil)
            }
            
        }
        
    }
    
    func updateUI(snapshotData: DataSnapshot?) {
        
        if positionToEdit == nil {
            // If this view is used for edit position, then we don't need picker view
            
            let currentInstrumentName = getInstrumentName()
            if let currentInstrumentRates = forexAPI.ratesByInstrumentName[currentInstrumentName] {
                positionOpenPrice.text = currentInstrumentRates
                positionStopLoss.text = currentInstrumentRates
                positionTakeProfit.text = currentInstrumentRates
            }
            
        } else {
            // If this view is used for edit position, then we need to get values for editable position
            
            let currentInstrumentName = getInstrumentName()
            if let currentInstrumentRates = forexAPI.ratesByInstrumentName[currentInstrumentName] {
                positionOpenPrice.text = currentInstrumentRates
                positionStopLoss.text = currentInstrumentRates
                positionTakeProfit.text = currentInstrumentRates
            }
            
        }
        
    }
    
    deinit {
        removeKeyboardNotifications()
    }
    @IBAction func clearTakeProfit(_ sender: UIButton) {
        positionTakeProfit.text = ""
    }
    
    @IBAction func clearStopLoss(_ sender: UIButton) {
        positionStopLoss.text = ""
    }
    
    @IBAction func sellOrBuyButtonPressed(_ sender: UIButton) {
        
        if sender.tag == 0 {
            // Was pressed Sell button
            
            // Get the dictionary with values from text fields
            guard let position = makePositionInstanceWithFieldsValues(dealDirection: "Sell")
                else { return }
            if positionToEdit == nil {
                coreDataManager.saveInDB(position)
                
            } else {
                
                // Update existing position
                
                
                
            }
            
            
        } else {
            // Was pressed Buy button
            
            // Get the dictionary with values from text fields
            guard let positionValuesDict = makePositionInstanceWithFieldsValues(dealDirection: "Buy")
                else { return }
            
            if positionToEdit == nil {
                
                // Add new position
                
                
            } else {
                
                // Update existing position
                
                // firebase.ref.child("positions").child(positionID).setValue(positionValuesDict)
                
            }
            
        }
        
        // Dismiss this view controller and go to previous
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
        
    }
    
    // This method saves last used settings in Picker View
    func saveLastUsedInstrument() {
        let lastUsedInstrument = LastUsedInstrument(categoryID: currentCategoryID,
                                                    leftPartID: currentInstrumentLeftPartID,
                                                    rightPartID: currentInstrumentRightPartID)
        
        options.lastUsedInstrument = lastUsedInstrument
    }
    
}

// Textfield Delegate
extension CalcAddItemVC: UITextFieldDelegate {
    
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
    func makePositionInstanceWithFieldsValues(dealDirection: String) -> Position? {
        
        //TODO: Make a check to have a correct results
        guard let value = positionValue.text?.myFloatConverter else {
            return nil
        }
        guard let openPrice = positionOpenPrice.text?.myFloatConverter else {
            return nil
        }
        guard let stopLoss = positionStopLoss.text?.myFloatConverter else {
            return nil
        }
        guard let takeProfit = positionTakeProfit.text?.myFloatConverter else {
            return nil
        }
        
        var instrumentParts = [String]()
        
        if let position = positionToEdit {
            // Means, if it is editing of the position from the calculator list
            
            instrumentParts = position.instrument.parts
            
        } else {
            // Means, if it is Adding a new position
            
            let instrumentLeftPart =
                instruments.getArrayWithInstrumentsBy(categoryID: currentCategoryID)[currentInstrumentLeftPartID]
            instrumentParts.append(instrumentLeftPart)
            
            let instrumentRightPart = instruments.getRightCurrencyPairsArrayFor(instrumentID: currentInstrumentLeftPartID, inCategoryID: currentCategoryID)[currentInstrumentRightPartID]
            instrumentParts.append(instrumentRightPart)
            
        }
        
        var currentCategoryIDForSave = 0
        
        if positionToEdit == nil {
            
            currentCategoryIDForSave = currentCategoryID
            
        } else {
            
            guard let categoryName = positionToEdit?.instrument.category
                else { return nil }
            
            guard let currentCategoryID = instruments.categories.index(of: categoryName)
                else { return nil }
            
            currentCategoryIDForSave = currentCategoryID
            
        }
        
        let categoryName = instruments.getCategoryNameBy(categoryID: currentCategoryIDForSave)
        
        // Make a Position with values for inserting to Core Data
        let positionInstance = Position(
            creationDate: NSDate(),
            instrument: Instrument(categoryName, instrumentParts),
            value: value,
            openPrice: openPrice,
            stopLoss: stopLoss,
            takeProfit: takeProfit,
            dealDirection: dealDirection)
        
        return positionInstance
    }
    
}

// Data Picker Delegates and methods
extension CalcAddItemVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Explanations 1: makeapppie.com/2014/10/21/swift-swift-formatting-a-uipickerview/
    // Explanations 2: makeapppie.com/2014/10/20/swift-swift-using-attributed-strings-in-swift/
    
    
    //TODO: Write a description
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 3
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            return instruments.categories.count
        } else if component == 1 {
            return instruments.getArrayWithInstrumentsBy(categoryID: currentCategoryID).count
        } else {
            return instruments.getRightCurrencyPairsArrayFor(instrumentID: currentInstrumentLeftPartID, inCategoryID: currentCategoryID).count
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
            titleData = instruments.getRightCurrencyPairsArrayFor(instrumentID: currentInstrumentLeftPartID, inCategoryID: currentCategoryID)[row]
            
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
            currentInstrumentLeftPartID = 0
            currentInstrumentRightPartID = 0
            pickerView.reloadComponent(1)
            pickerView.reloadComponent(2)
            pickerView.selectRow(0, inComponent: 1, animated: true)
            pickerView.selectRow(0, inComponent: 2, animated: true)
            
            
        } else if component == 1 {
            
            currentInstrumentLeftPartID = row
            currentInstrumentRightPartID = 0
            
            pickerView.reloadComponent(2)
            pickerView.selectRow(0, inComponent: 2, animated: true)
            
            // Get the description of the Instrument
            getDescriptionOfInstrument()
            
        } else {
            
            currentInstrumentRightPartID = row
            
            
        }
        
        // Get the description of the Instrument
        getDescriptionOfInstrument()
        
        updateUI(snapshotData: nil)
        saveLastUsedInstrument()
        
    }
    
    // Get Name of the Instrument
    func getInstrumentName() -> String {
        
        var instrumentName = ""
        if let unwrappedPositionToEdit = positionToEdit {
            // If it is a process of editing existing position from the calculator list
            
            instrumentName = unwrappedPositionToEdit.instrument.name
            
        } else {
            // If it is a process of adding a new position
            
            instrumentName = instruments.getInstrumentNameBy(categoryID: currentCategoryID,
                                                                         leftPart: currentInstrumentLeftPartID,
                                                                         rightPart: currentInstrumentRightPartID)
        }
        
        return instrumentName
        
    }
    
    // Get the description of the Instrument
    func getDescriptionOfInstrument() {
        
        // New code
        var description = ""
        var instrumentParts = [String]()
        if let position = positionToEdit {
            instrumentParts = position.instrument.parts
        } else {
            let instrument = instruments.getInstrumentObject(categoryID: currentCategoryID,
                                                             leftPart: currentInstrumentLeftPartID,
                                                             rightPart: currentInstrumentRightPartID)
            instrumentParts = instrument.parts
        }
        
        //
        var iterator = 0
        
        for instrumentPart in instrumentParts {
            
            guard let fullPartName = instrumentPartFullName[instrumentPart]
                else { return }
            
            if iterator == 0 {
                description += fullPartName
            } else {
                description += " vs " + fullPartName
            }
            
            iterator += 1
            
        }
        
        instrumentDescription.text = description
        
    }
    
}









