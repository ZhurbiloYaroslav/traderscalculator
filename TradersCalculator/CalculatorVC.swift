//
//  CalculatorVC.swift
//  TradersCalculator
//
//  Created by Yaroslav Zhurbilo on 09.07.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit
import GoogleMobileAds
import FirebaseDatabase
import FirebaseAuth
import CoreData

class CalculatorVC: UIViewController, GADBannerViewDelegate {
    
    @IBOutlet weak var totalProfitLabel: UILabel!
    @IBOutlet weak var totalLossLabel: UILabel!
    @IBOutlet weak var totalMarginLabel: UILabel!
    
    @IBOutlet weak var googleBannerView: GADBannerView!
    @IBOutlet weak var calculatorTableView: UITableView!
    
    var firebase: FirebaseConnect!  // Reference variable for the Database
    var adMob: AdMob!
    var positionsArray: [Position]!
    var positionsArrayByID: [String: Position]!
    var openedPositionCell: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init delegates
        initDelegates()
        
        initializeVariables()
        
        // Configure the Firebase
        firebase = FirebaseConnect()
        
        // adMob
        adMob = AdMob()
        adMob.getLittleBannerFor(viewController: self, adBannerView: googleBannerView)
        
        // Set the observer for Firebase data
        firebase.ref.observe(.value, with: { snapshot in
            self.updateTable(snapshot)
        })
        
    }
    
    // Init delegates
    func initDelegates() {
        
        calculatorTableView.delegate = self
        calculatorTableView.dataSource = self
        
    }
    
    func initializeVariables() {
        
        //
        
        let userDefaults = UserDefaultsManager()
        
        if userDefaults.accountCurrency == nil || userDefaults.leverage == nil {
            performSegue(withIdentifier: "chooseParamsAtFirstLaunch", sender: nil)
        }
        
        //
        
        positionsArray = [Position]()
        
        longTapOnCellRecognizerSetup()
        
        calculatorTableView.estimatedRowHeight = 100
        calculatorTableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    
    
    func longTapOnCellRecognizerSetup() {
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(CalculatorVC.longPress))
        longPressGesture.minimumPressDuration = 1.0 // 1 second press
        longPressGesture.delegate = self as? UIGestureRecognizerDelegate
        calculatorTableView.addGestureRecognizer(longPressGesture)
        
    }
    
    // Make request to the server
    func makeRequest() {
        
        let forexAPI = ForexAPI()
        forexAPI.downloadInstrumentsRates {
            
        }
        
    }
    
    // Changes the top Total: Profit, Loss and Margin values
    func changeTopTotalValues() {
        
        var totalProfitValue: Double = 0
        var totalLossValue: Double = 0
        var totalMarginValue: Double = 0
        
        // Iterate through positions array to get all values
        for position in positionsArray {
            //---Back---
            if let profit = Double(position.getProfit()) {
                totalProfitValue += profit
            }
            if let loss = Double(position.getLoss()) {
                totalLossValue += loss
            }
            if let margin = Double(position.getMargin()) {
                totalMarginValue += margin
            }
            
        }
        
        // Update the Total Label's values
        totalProfitLabel.text = String(format: "%.2f", totalProfitValue)
        totalLossLabel.text = String(format: "%.2f", totalLossValue)
        totalMarginLabel.text = String(format: "%.2f", totalMarginValue)
        
    }
    
    //TODO: Make description
    @IBAction func backToCalculatorFromAddPositionWithoutSaving(sender: UIStoryboardSegue) {
        
    }
    
    //TODO: Make description
    @IBAction func backToCalculatorFromParamsSelectionPage(sender: UIStoryboardSegue) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Remove Firebase Authenticate listener
        if let tempHandle = firebase.handle {
            Auth.auth().removeStateDidChangeListener(tempHandle)
        }
        
    }
    
}

extension CalculatorVC: NSFetchedResultsControllerDelegate {
    
    
    
}

// Table view delegates and methods
extension CalculatorVC: UITableViewDelegate, UITableViewDataSource {
    
    
    // Update the table with owners list at the begining and after changes in Firebase
    func updateTable(_ snapshot: DataSnapshot) {
        
        // Define variable with the whole data from Database
        guard let snapshotValue = snapshot.value as? [String: Any] else {
            return
        }
        
        // Define variable with only the list of positions
        guard let positionsArrayFromFirebase = snapshotValue["positions"] as? [String: [String: Any]] else {
            return
        }
        
        // Make a temporary variable for storing owners list from Firebase
        var updatedPositionsArray = [Position]()
        var updatedPositionsArrayByID = [String: Position]()
        
        // Make objects of the owners list from Firebase and put them in the array
        for (positionID, firebaseDict) in positionsArrayFromFirebase {
            let position = Position(positionID, firebaseDict)
            updatedPositionsArray.append(position)
            updatedPositionsArrayByID.updateValue(position, forKey: positionID)
        }
        
        // Update this class variable with data from Firebase
        positionsArray = updatedPositionsArray
        positionsArrayByID = updatedPositionsArrayByID
        
        // Changes the top Total: Profit, Loss and Margin values
        changeTopTotalValues()
        
        calculatorTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //TODO: Change it
        return positionsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CalculatedPositionCell") as? CalculatorItemCell
            else { return UITableViewCell() }
        
        cell.cellIsOpen = false
        
        if let openedCell = openedPositionCell, openedCell == indexPath.row {
            cell.cellIsOpen = true
        }
        
        cell.updateCell(position: positionsArray[indexPath.row])
        
        return cell
    }
    
    //Called, when long press occurred
    func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        
        if longPressGestureRecognizer.state == UIGestureRecognizerState.began {
            
            let touchPoint = longPressGestureRecognizer.location(in: self.calculatorTableView)
            if let indexPath = calculatorTableView.indexPathForRow(at: touchPoint) {
                
                performAlertOnLongPressOnCellWith(indexPath)
            }
            
        }
    }
    
    //TODO: Make description
    func performAlertOnLongPressOnCellWith(_ indexPath: IndexPath) {
        
        let currentPosition = positionsArray[indexPath.row]
        let positionName = currentPosition.instrument
        let alert = UIAlertController(title: nil, message: "\(positionName)", preferredStyle: .actionSheet)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            
            // Deleting the position
            let deletingPositionID = self.positionsArray[indexPath.row].positionID
            self.positionsArray.remove(at: indexPath.row)
            self.firebase.ref.child("positions").child(deletingPositionID).removeValue()
            self.calculatorTableView.reloadData()
            
        }
        let EditAction = UIAlertAction(title: "Edit", style: .default) { (action) in
            
            self.performSegue(withIdentifier: "EditPosition", sender: currentPosition)
            
        }
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(DeleteAction)
        alert.addAction(EditAction)
        alert.addAction(CancelAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //TODO: Make description
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueID = segue.identifier
            else { return }
        
        switch segueID {
        case "chooseParamsAtFirstLaunch":
            
            guard let destination = segue.destination as? OptSelectParamsVC
                else { return }
            
            destination.doWeChooseParamsAtFirstLaunch = true
 
            
        case "EditPosition":
            guard let destination = segue.destination as? CalcAddItemVC
                else { return }
            guard let currentPosition = sender as? Position
                else { return }
            destination.positionToEdit = currentPosition
            
        default: break
        }
        
    }
    
    //TODO: Make description
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        openedPositionCell = indexPath.row
        
        tableView.reloadData()
        
    }
    
}














