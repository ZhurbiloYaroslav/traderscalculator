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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init delegates
        initDelegates()
        
        // Configure the Firebase
        firebase = FirebaseConnect()
        
        // adMob
        adMob = AdMob()
        adMob.getLittleBannerFor(viewController: self, andBannerView: googleBannerView)
        
        // Set the observer for Firebase data
        firebase.ref.observe(.value, with: { snapshot in
            // Make changes
        })
        
    }
    
    // Init delegates
    func initDelegates() {
        
        calculatorTableView.delegate = self
        calculatorTableView.dataSource = self
        
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //TODO: Change it
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CalculatorItemCell")
//            else { return UITableViewCell() }
        
        return UITableViewCell()
    }
    
}








