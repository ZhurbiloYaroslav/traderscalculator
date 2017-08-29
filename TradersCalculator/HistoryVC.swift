//
//  HistoryVC.swift
//  TradersCalculator
//
//  Created by Yaroslav Zhurbilo on 15.07.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit
import GoogleMobileAds

class HistoryVC: UIViewController {
    
    @IBOutlet weak var calendarTableView: UITableView!
    @IBOutlet weak var googleBannerView: GADBannerView!
    
    var adMob: AdMob!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init delegates
        initDelegates()
        
        initializeVariables()
        
        // adMob
        adMob = AdMob()
        adMob.getLittleBannerFor(viewController: self, adBannerView: googleBannerView)
        
    }
    
    // Init delegates
    func initDelegates() {
        
        calendarTableView.delegate = self
        calendarTableView.dataSource = self
        
    }
    
    func initializeVariables() {
        
        calendarTableView.estimatedRowHeight = 60
        calendarTableView.rowHeight = UITableViewAutomaticDimension
        calendarTableView.sectionFooterHeight = 0
        
    }

}

// Methods related with a Table View
extension HistoryVC: UITableViewDelegate, UITableViewDataSource {
    
    //TODO: This post helps to hold headers of the section on top
    // medium.com/ios-os-x-development/ios-how-to-build-a-table-view-with-multiple-cell-types-2df91a206429
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as? HistoryCell else { return UITableViewCell() }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "CalendarShowEventDetails", sender: "EventID")
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
}





