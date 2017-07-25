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

class CalculatorVC: UIViewController, GADBannerViewDelegate {
    
    @IBOutlet weak var googleBannerView: GADBannerView!
    @IBOutlet weak var calculatorTableView: UITableView!
    
    var firebase: FirebaseConnect!  // Reference variable for the Database
    var adMob: AdMob!
    var positionsArray: [Position]!
    
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
    
    //TODO: Make description
    @IBAction func backToCalculatorFromAddPositionWithoutSaving(sender: UIStoryboardSegue) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Remove Firebase Authenticate listener
        if let tempHandle = firebase.handle {
            Auth.auth().removeStateDidChangeListener(tempHandle)
        }
        
    }
    
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
        
        // Make objects of the owners list from Firebase and put them in the array
        for (key, value) in positionsArrayFromFirebase {
            let position = Position(positionID: key, firebaseDict: value)
            updatedPositionsArray.append(position)
        }
        
        // Update this class variable with data from Firebase
        positionsArray = updatedPositionsArray
        calculatorTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //TODO: Change it
        return positionsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CalculatedPositionCell") as? CalculatorItemCell
            else { return UITableViewCell() }
        
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
        let positionIDinFirebase = currentPosition.positionID
        let alert = UIAlertController(title: nil, message: "\(positionName)", preferredStyle: .actionSheet)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            
            // Deleting the position
            let deletingPositionID = self.positionsArray[indexPath.row].positionID
            self.positionsArray.remove(at: indexPath.row)
            self.firebase.ref.child("positions").child(deletingPositionID).removeValue()
            self.calculatorTableView.reloadData()
            
        }
        let EditAction = UIAlertAction(title: "Edit", style: .default) { (action) in
            
            self.performSegue(withIdentifier: "EditPosition", sender: positionIDinFirebase)
            
        }
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(DeleteAction)
        alert.addAction(EditAction)
        alert.addAction(CancelAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //TODO: Make description
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? CalcAddItemVC
            else { return }
        guard let positionID = sender as? String
            else { return }
        destination.positionIDToEdit = positionID
    }
    
    //TODO: Make description
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) as? CalculatorItemCell {
            
            if cell.cellIsOpen {
                cell.cellIsOpen = false
            } else {
                cell.cellIsOpen = true
            }
            print(cell.cellIsOpen)
            tableView.reloadData()
        }
        
    }
    
    
    
}








