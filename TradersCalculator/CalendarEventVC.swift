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
        eventTableView.estimatedRowHeight = 60
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
}

extension CalendarEventVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        switch indexPath.section {
        case 0:
            guard let descCell = tableView.dequeueReusableCell(withIdentifier: "CalendarCellEventDesc", for: indexPath) as? CalendarCellEventDesc
                else { return UITableViewCell() }
            print("Section 1", indexPath.section)
            cell = descCell
            break
            
        case 1:
            guard let historyCell = tableView.dequeueReusableCell(withIdentifier: "CalendarCellEventHistory", for: indexPath) as? CalendarCellEventHistory
                else { return UITableViewCell() }
            print("Section 2", indexPath.section)
            cell = historyCell
            break
            
        default:
            break
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "Section"
        /*
        switch section {
        case 0:
            return "Event Description"
        case 1:
            return "History"
        default:
            return ""
        }
        */
    }
    
}




