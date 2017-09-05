//
//  HistoryVC.swift
//  TradersCalculator
//
//  Created by Yaroslav Zhurbilo on 15.07.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit
import GoogleMobileAds
import CoreData

class HistoryVC: UIViewController {
    
    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak var googleBannerView: GADBannerView!
    
    var adMob: AdMob!
    var arrayWithListOfPositions: [ListOfPositions]!
    
    var userDefaultsManager: UserDefaultsManager!
    var coreDataManager: CoreDataManager!
    var context: NSManagedObjectContext!
    //var controller: NSFetchedResultsController<ListOfPositions>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init delegates
        initDelegates()
        
        initializeVariables()
        
        // adMob
        adMob = AdMob()
        adMob.getLittleBannerFor(viewController: self, adBannerView: googleBannerView)
        
        longTapOnCellRecognizerSetup()

    }
    
    // Init delegates
    func initDelegates() {
        
        historyTableView.delegate = self
        historyTableView.dataSource = self
        
    }
    
    func initializeVariables() {
        
        userDefaultsManager = UserDefaultsManager()
        coreDataManager = CoreDataManager()
        context = coreDataManager.context
        arrayWithListOfPositions = coreDataManager.getAllListsOfPositions()
        
        historyTableView.estimatedRowHeight = 60
        historyTableView.rowHeight = UITableViewAutomaticDimension
        historyTableView.sectionFooterHeight = 0
        
    }
    
    func longTapOnCellRecognizerSetup() {
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(CalculatorVC.longPress))
        longPressGesture.minimumPressDuration = 1.0 // 1 second press
        longPressGesture.delegate = self as? UIGestureRecognizerDelegate
        historyTableView.addGestureRecognizer(longPressGesture)
        
    }
    
    @IBAction func addLIstButtonPressed(_ sender: UIBarButtonItem) {
        _ = ListOfPositions(needSave: true)
        coreDataManager.saveContext()
        
        arrayWithListOfPositions = coreDataManager.getAllListsOfPositions()
        historyTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        historyTableView.reloadData()
    }

}

// Methods related with a Table View
extension HistoryVC: UITableViewDelegate, UITableViewDataSource {
    
    //TODO: This post helps to hold headers of the section on top
    // medium.com/ios-os-x-development/ios-how-to-build-a-table-view-with-multiple-cell-types-2df91a206429
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrayWithListOfPositions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as? HistoryCell else { return UITableViewCell() }
        cell.updateCell(arrayWithListOfPositions[indexPath.row])
        
        return cell
    }
    
    func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        
        if longPressGestureRecognizer.state == UIGestureRecognizerState.began {
            
            let touchPoint = longPressGestureRecognizer.location(in: self.historyTableView)
            if let indexPath = historyTableView.indexPathForRow(at: touchPoint) {
                
                performAlertOnLongPressOnCellWith(indexPath)
            }
            
        }
    }
    
    func performAlertOnLongPressOnCellWith(_ indexPath: IndexPath) {
        
        let currentList = arrayWithListOfPositions[indexPath.row]
        let listName = currentList.listName
        let alert = UIAlertController(title: nil, message: "\(listName)", preferredStyle: .actionSheet)
        
        let openAction = UIAlertAction(title: "Open", style: .default) { (action) in
            
            let currentListIdURL = currentList.objectID.uriRepresentation()
            UserDefaultsManager().currentListOfPositionsID = currentListIdURL
            
        }
        
        let editAction = UIAlertAction(title: "Edit name", style: .default) { (action) in
            
            //TODO:
            
        }
        
        let exportAction = UIAlertAction(title: "Export", style: .default) { (action) in
            
            //TODO:
            
        }
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            
            // let deletingPositionID = self.positionsArray[indexPath.row].positionID
            // self.positionsArray.remove(at: indexPath.row)
            // self.firebase.ref.child("positions").child(deletingPositionID).removeValue()
            // self.calculatorTableView.reloadData()
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(openAction)
        alert.addAction(editAction)
        alert.addAction(exportAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
}





