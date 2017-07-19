//
//  CalculatorVC.swift
//  TradersCalculator
//
//  Created by Yaroslav Zhurbilo on 09.07.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit
import GoogleMobileAds

class CalculatorVC: UIViewController {
    
    @IBOutlet weak var googleBannerView: GADBannerView!
    
    @IBOutlet weak var calculatorTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init delegates
        initDelegates()
        
        // adMob
        adMob()
        
        // Make request to the server
//        makeRequest()
    }
    
    // Init delegates
    func initDelegates() {
        
        calculatorTableView.delegate = self
        calculatorTableView.dataSource = self
        
    }
    
    //ADMOB
    func adMob() {
        
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        
        googleBannerView.adUnitID = "ca-app-pub-7923953444264875/5465129548"
        googleBannerView.rootViewController = self
        googleBannerView.load(request)
        
    }
    
    // Make request to the server
    func makeRequest() {
        
        let forexAPI = ForexAPI()
        forexAPI.downloadForexData {
            
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








