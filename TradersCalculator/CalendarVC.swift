//
//  CalendarVC.swift
//  TradersCalculator
//
//  Created by Yaroslav Zhurbilo on 15.07.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit
import GoogleMobileAds
import FirebaseDatabase
import FirebaseAuth

class CalendarVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var scrollViewForSegmentedControl: UIScrollView!
    @IBOutlet weak var calendarTableView: UITableView!
    @IBOutlet weak var googleBannerView: GADBannerView!
    
    
    var firebase: FirebaseConnect!  // Reference variable for the Database
    var adMob: AdMob!
    
    var currentDateSegmentedControlValue: Int!
    var calendarOneDayEvents: [CalendarEvent]!
    var calendarEventsTomor: [CalendarEvent]!
    var calendarEventsWeek: [[String: [CalendarEvent]]]!
    var dateCellsTitles: [String]!
    var selectedDateInScrollView: Int!
    
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
//            self.updateTable(snapshot)
        })
        
    }
    
    // Init delegates
    func initDelegates() {
        
        calendarTableView.delegate = self
        calendarTableView.dataSource = self
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    func initializeVariables() {
        
//        scrollViewForSegmentedControl.contentSize.width = 400
        dateCellsTitles = ["Yesterday", "Today", "Tomorrow", "This week", "Next week"]
        selectedDateInScrollView = 1
        
        /// For testing purposes Start
        calendarOneDayEvents = [CalendarEvent]()
        calendarEventsTomor = [CalendarEvent]()
        calendarEventsWeek = [[String:[CalendarEvent]]]()
        
        var events = [CalendarEvent]()
        
        for _ in 1...10 {
            
            events.append(CalendarEvent())
        }
        
        calendarOneDayEvents = events
        calendarEventsWeek.append(["date 1": events])
        calendarEventsWeek.append(["date 2": events])
        calendarEventsWeek.append(["date 3": events])
        /// For testing purposes End
        
        calendarTableView.estimatedRowHeight = 60
        calendarTableView.rowHeight = UITableViewAutomaticDimension
//        calendarTableView.sectionHeaderHeight = 0
        calendarTableView.sectionFooterHeight = 0
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Remove Firebase Authenticate listener
        if let tempHandle = firebase.handle {
            Auth.auth().removeStateDidChangeListener(tempHandle)
        }
        
    }

}

// Methods related with a Table View
extension CalendarVC: UITableViewDelegate, UITableViewDataSource {
    
    //TODO: This post helps to hold headers of the section on top
    // medium.com/ios-os-x-development/ios-how-to-build-a-table-view-with-multiple-cell-types-2df91a206429
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        switch selectedDateInScrollView {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 1
        default:
            return 3
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarCell", for: indexPath) as? CalendarCell else { return UITableViewCell() }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "date"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "CalendarShowEventDetails", sender: "EventID")
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let segueID = segue.identifier
            else { return }
        
        
        switch segueID {
        case "CalendarShowEventDetails":
            guard let destination = segue.destination as? CalendarEventVC
                else { return }
            guard let eventID = sender as? String
                else { return }
            destination.eventID = eventID
            
        default: break
        }
    }
    
}

// Methods related to the UICollection View
extension CalendarVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCollectionCell",
                                                         for: indexPath) as? CalendarHorizontalScrollCell {
            
            cell.title.text = dateCellsTitles[indexPath.row]
            cell.title.textColor = UIColor.darkGray
            
            if selectedDateInScrollView == indexPath.row {
                cell.title.textColor = UIColor.black
            }
            
            return cell
        } else {
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedDateInScrollView = indexPath.row
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        collectionView.reloadData()
        calendarTableView.reloadData()
    }
    
    
}




