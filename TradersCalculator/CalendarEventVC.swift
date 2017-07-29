//
//  CalendarEventVC.swift
//  TradersCalculator
//
//  Created by Yaroslav Zhurbilo on 26.07.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit
import GoogleMobileAds

class CalendarEventVC: UIViewController {
    
    @IBOutlet weak var eventTableView: UITableView!
    @IBOutlet weak var googleBannerView: GADBannerView!
    
    var adMob: AdMob!
    
    var eventID: String?

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
        
        eventTableView.delegate = self
        eventTableView.dataSource = self
        
    }
    
    func initializeVariables() {
        
        self.navigationItem.title = "Event Info"
        
        eventTableView.rowHeight = UITableViewAutomaticDimension
        eventTableView.sectionFooterHeight = 0
    }
}

extension CalendarEventVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        default:
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath {
            
        // Means, that this is a description of the Calendar's Event
        case [0, 0]:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarCellEventDesc", for: indexPath) as? CalendarCellEventDesc
                else { return UITableViewCell() }

            return cell
            
        // Means, that this is a title of the History Table
        case [1, 0]:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarCellEventHistoryTitle", for: indexPath) as? CalendarCellEventHistoryTitle
                else { return UITableViewCell() }

            return cell
            
        // Means, that this is a row in the History Table
        default:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarCellEventHistoryData", for: indexPath) as? CalendarCellEventHistoryData
                else { return UITableViewCell() }
            
            
            let historyValues = [
                "Release Date" : "Jul 26, 2017",
                "Actual" : "40.2K",
                "Forecast" : "39.9K",
                "Previous" : "40.3K"
            ]
            
            cell.updateCell(historyValues)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 1:
            return "History"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            return 200
        default:
            return 40
        }
    }
    
}




