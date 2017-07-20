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

class CalculatorVC: UIViewController {
    
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
        adMob.getLittleBannerFor(viewController: self, andBannerView: googleBannerView)
        
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
        
        navigationItem.title = "500 USD"
//        navigationController?.navigationBar.barTintColor = UIColor.blue
        
    }
    
    // Make request to the server
    func makeRequest() {
        
        let forexAPI = ForexAPI()
        forexAPI.downloadInstrumentsRates {
            print(forexAPI.ratesByInstrumentName)
        }
        
    }
    
//    //TODO: Make description
//    @IBAction func unwindToCalculatorWithSavePosition(sender: UIStoryboardSegue) {
//        if let sourceViewController = sender.source as? CalcAddItemVC {
////            dataRecieved = sourceViewController.dataPassed
//        }
//    }
    
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
    
}








