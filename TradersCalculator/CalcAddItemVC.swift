//
//  CalcAddItemVC.swift
//  TradersCalculator
//
//  Created by Yaroslav Zhurbilo on 15.07.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit

class CalcAddItemVC: UIViewController {
    
    @IBOutlet weak var navigationBackButton: UIButton!
    @IBOutlet weak var navigationBarTitle: UILabel!
    @IBOutlet weak var viewInScrollView: UIView!
    @IBOutlet weak var googleBannerView: AdBannerView!
    @IBOutlet weak var instrumentsPicker: UIPickerView!
    @IBOutlet weak var instrumentDescription: UILabel!
    @IBOutlet weak var positionValue: UITextField!
    @IBOutlet weak var positionOpenPrice: UITextField!
    @IBOutlet weak var positionTakeProfit: UITextField!
    @IBOutlet weak var positionStopLoss: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackWithInstrumentPicker: UIStackView!
    
    @IBOutlet weak var instrumentsPickerDescription: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var openPriceLabel: UILabel!
    @IBOutlet weak var takeProfitLabel: UILabel!
    @IBOutlet weak var stopLossLabel: UILabel!
    @IBOutlet weak var sellButton: UIButton!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var clearProfitButton: UIButton!
    @IBOutlet weak var clearLossButton: UIButton!
    
    @IBOutlet weak var containerConstraintToChange: NSLayoutConstraint!
    
    var options: UserDefaultsManager!
    var forexAPI: ForexAPI!
    
    var freeOrProVersion: FreeOrProVersion!
    var coreDataManager = CoreDataManager()
    var instruments = Instruments()
    var currentCategoryID: Int!
    var currentInstrumentLeftPartID: Int!
    var currentInstrumentRightPartID: Int!
    
    var positionToEdit: Position?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUILabelsWithLocalizedText()
        
        initDelegates()
        
        options = UserDefaultsManager()
        
        makeRequest()
        
        initializeVariables()
        
        registerForKeyboardNotifications()
        
    }
    
    func updateUILabelsWithLocalizedText() {
        
        instrumentsPickerDescription.text = "".localized()
        
        valueLabel.text = "Value".localized()
        openPriceLabel.text = "Open price".localized()
        takeProfitLabel.text = "Take profit".localized()
        stopLossLabel.text = "Stop loss".localized()
        sellButton.setTitle("Sell".localized(), for: .normal)
        buyButton.setTitle("Buy".localized(), for: .normal)
//        navigationBackButton.setTitle("Back".localized(), for: .normal)
        clearProfitButton.setTitle("clear".localized(), for: .normal)
        clearLossButton.setTitle("clear".localized(), for: .normal)
        
        if positionToEdit != nil {
            navigationBarTitle.text = "Edit position #navBarTitle".localized()
        } else {
            navigationBarTitle.text = "Add position".localized()
        }
        
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
        
        freeOrProVersion = FreeOrProVersion(bannerView: googleBannerView,
                                            constraint: containerConstraintToChange,
                                            tableViewToChange: nil)
        
        googleBannerView.configure()
        
        let lastUsedInstrument = options.lastUsedInstrument
        currentCategoryID = lastUsedInstrument.categoryID
        currentInstrumentLeftPartID = lastUsedInstrument.instrumentLeftPartID
        currentInstrumentRightPartID = lastUsedInstrument.instrumentRightPartID
        
        instrumentsPicker.selectRow(currentCategoryID, inComponent: 0, animated: true)
        instrumentsPicker.selectRow(currentInstrumentLeftPartID, inComponent: 1, animated: true)
        instrumentsPicker.selectRow(currentInstrumentRightPartID, inComponent: 2, animated: true)
        
        getDescriptionOfInstrument()
        
        if let position = positionToEdit {
            
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
                self.updateUI()
            }
            
        }
        
    }
    
    func updateUI() {
        
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
            // Pressed Sell
            makePositionInstanceWithFieldsValues(dealDirection: "Sell")
            
        } else {
            // Pressed Buy
            makePositionInstanceWithFieldsValues(dealDirection: "Buy")
            
        }
        coreDataManager.saveContext()
        
        performSegue(withIdentifier: "showFullScreenAdvert", sender: nil)
        // Dismiss this view controller and go to previous
//        navigationController?.popViewController(animated: true)
//        dismiss(animated: true, completion: nil)
        
    }
    
    // This method saves last used settings in Picker View
    func saveLastUsedInstrument() {
        let lastUsedInstrument = LastUsedInstrument(categoryID: currentCategoryID,
                                                    leftPartID: currentInstrumentLeftPartID,
                                                    rightPartID: currentInstrumentRightPartID)
        
        options.lastUsedInstrument = lastUsedInstrument
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        freeOrProVersion.removeAdIfPRO()
        
        updateUILabelsWithLocalizedText()
        
        _ = HonestCustomer(withVC: self)
        
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

extension CalcAddItemVC {
    
    //TODO: Make a description
    func makePositionInstanceWithFieldsValues(dealDirection: String) {
        
        //TODO: Make a check to have a correct results
        guard let value = positionValue.text?.myFloatConverter else {
            return
        }
        guard let openPrice = positionOpenPrice.text?.myFloatConverter else {
            return
        }
        guard let stopLoss = positionStopLoss.text?.myFloatConverter else {
            return
        }
        guard let takeProfit = positionTakeProfit.text?.myFloatConverter else {
            return
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
                else { return }
            
            guard let currentCategoryID = instruments.categories.index(of: categoryName)
                else { return }
            
            currentCategoryIDForSave = currentCategoryID
            
        }
        
        if positionToEdit == nil {
            
            let categoryName = instruments.getCategoryNameBy(categoryID: currentCategoryIDForSave)
            
            _ = Position(
                needSave: true,
                creationDate: NSDate(),
                instrument: Instrument(needSave: true, categoryName, instrumentParts),
                value: value,
                openPrice: openPrice,
                stopLoss: stopLoss,
                takeProfit: takeProfit,
                dealDirection: dealDirection)
            
        } else {
            
            positionToEdit?.value = value
            positionToEdit?.openPrice = openPrice
            positionToEdit?.stopLoss = stopLoss
            positionToEdit?.takeProfit = takeProfit
            positionToEdit?.dealDirection = dealDirection
            
        }
        
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
        
        updateUI()
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
            instrumentParts = instruments.getInstrumentParts(categoryID: currentCategoryID,
                                                             leftPart: currentInstrumentLeftPartID,
                                                             rightPart: currentInstrumentRightPartID)
        }
        
        //
        var iterator = 0
        
        for instrumentPart in instrumentParts {
            
            guard let fullPartName = Currency.instrumentPartFullName[instrumentPart]
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









