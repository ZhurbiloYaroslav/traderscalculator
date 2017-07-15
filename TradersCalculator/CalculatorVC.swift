//
//  CalculatorVC.swift
//  TradersCalculator
//
//  Created by Yaroslav Zhurbilo on 09.07.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit

class CalculatorVC: UIViewController {
    
    //TODO: insert the tableview

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: associate tableview delegate with self
        
        // Make request to the server
        makeRequest()
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
        
        
        return UITableViewCell()
    }
    
}








