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
    var openedCell: Int?
    var arrayWithListOfPositions: [ListOfPositions]!
    
    var userDefaultsManager: UserDefaultsManager!
    var coreDataManager: CoreDataManager!
    var context: NSManagedObjectContext!
    var controller: NSFetchedResultsController<ListOfPositions>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUILabelsWithLocalizedText()
        
        initDelegates()
        
        initializeVariables()
        
        adMob = AdMob()
        adMob.getLittleBannerFor(viewController: self, adBannerView: googleBannerView)
        
        attemptFetch()

        longTapOnCellRecognizerSetup()

    }
    
    func updateUILabelsWithLocalizedText() {
        
        navigationItem.title = "History".localized()
        
    }
    
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
        
        updateUILabelsWithLocalizedText()
        
        historyTableView.reloadData()
    }

}

extension HistoryVC: NSFetchedResultsControllerDelegate {
    
    func attemptFetch() {
        
        let fetchRequest: NSFetchRequest<ListOfPositions> = ListOfPositions.fetchRequest()
        let sortDescriptor  = NSSortDescriptor(key: "creationDate", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        
        do {
            try controller.performFetch()
        } catch {
            let error = error as NSError
            print("\(error)")
        }
    }
    
    func update(cell: HistoryCell, indexPath: IndexPath) {
        
        let item = controller.object(at: indexPath)
        
        cell.updateCell(item)
        
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        historyTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        historyTableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                historyTableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                historyTableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .move:
            if let newIndexPath = newIndexPath, let indexPath = indexPath {
                historyTableView.moveRow(at: indexPath, to: newIndexPath)
            }
        case .update:
            if let indexPath = indexPath {
                let cell = historyTableView.cellForRow(at: indexPath) as! HistoryCell
                update(cell: cell, indexPath: indexPath)
            }
        }
    }
    
}

// Methods related with a Table View
extension HistoryVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sections = controller.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell") as? HistoryCell else { return UITableViewCell()
        }
        
        cell.cellIsOpen = false
        
        if let openedCell = openedCell, openedCell == indexPath.row {
            cell.cellIsOpen = true
        }
        
        cell.updateCell(controller.object(at: indexPath))
        
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
        
        let editedListOfPositions = arrayWithListOfPositions[indexPath.row]
        let listName = editedListOfPositions.listName
        let alert = UIAlertController(title: nil, message: "\(listName)", preferredStyle: .actionSheet)
        
        let titleForOpenAction = "Open".localized()
        let openAction = UIAlertAction(title: titleForOpenAction, style: .default) { (action) in
            
            let currentListIdURL = editedListOfPositions.objectID.uriRepresentation()
            UserDefaultsManager().currentListOfPositionsID = currentListIdURL
            
        }
        
        let titleForEditAction = "Edit name".localized()
        let editAction = UIAlertAction(title: titleForEditAction, style: .default) { (action) in
            
            //TODO:
            
        }
        
        let titleForExportAction = "Export".localized()
        let exportAction = UIAlertAction(title: titleForExportAction, style: .default) { (action) in
            
            //TODO:
            
        }
        
        let titleForDeleteAction = "Delete".localized()
        let deleteAction = UIAlertAction(title: titleForDeleteAction, style: .destructive) { (action) in
            
            self.context.delete(editedListOfPositions)
            self.coreDataManager.saveContext()
            
        }
        
        let titleForCancelAction = "Cancel".localized()
        let cancelAction = UIAlertAction(title: titleForCancelAction, style: .cancel, handler: nil)
        
        alert.addAction(openAction)
        alert.addAction(editAction)
        alert.addAction(exportAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if openedCell == indexPath.row {
            openedCell = nil
        } else {
            openedCell = indexPath.row
        }
        
        tableView.reloadData()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
}




