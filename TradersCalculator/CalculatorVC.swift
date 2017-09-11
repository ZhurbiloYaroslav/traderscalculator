//
//  CalculatorVC.swift
//  TradersCalculator
//
//  Created by Yaroslav Zhurbilo on 09.07.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit
import GoogleMobileAds
import CoreData

class CalculatorVC: UIViewController, GADBannerViewDelegate {
    
    @IBOutlet weak var totalProfitLabel: UILabel!
    @IBOutlet weak var totalLossLabel: UILabel!
    @IBOutlet weak var totalMarginLabel: UILabel!
    @IBOutlet weak var currentListOfPositionsNameLabel: UILabel!
    
    @IBOutlet weak var googleBannerView: GADBannerView!
    @IBOutlet weak var calculatorTableView: UITableView!
    
    var adMob: AdMob!
    var openedCell: Int?
    
    var userDefaultsManager: UserDefaultsManager!
    var coreDataManager: CoreDataManager!
    var context: NSManagedObjectContext!
    var controller: NSFetchedResultsController<Position>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUILabelsWithLocalizedText()
        
        initDelegates()
        
        initializeVariables()
        
        adMob = AdMob()
        adMob.getLittleBannerFor(viewController: self, adBannerView: googleBannerView)
        
        attemptFetch()
        
    }
    
    
    func updateUILabelsWithLocalizedText() {
        
        
    }
    
    func initializeVariables() {
        
        controller = NSFetchedResultsController<Position>()
        userDefaultsManager = UserDefaultsManager()
        coreDataManager = CoreDataManager()
        context = coreDataManager.context
        updateTable()
        
        let userDefaults = UserDefaultsManager()
        
        if userDefaults.accountCurrency == nil || userDefaults.leverage == nil {
            performSegue(withIdentifier: "chooseParamsAtFirstLaunch", sender: nil)
        }
        
        longTapOnCellRecognizerSetup()
        
        calculatorTableView.estimatedRowHeight = 100
        calculatorTableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    func initDelegates() {
        
        calculatorTableView.delegate = self
        calculatorTableView.dataSource = self
        
    }
    
    func longTapOnCellRecognizerSetup() {
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(CalculatorVC.longPress))
        longPressGesture.minimumPressDuration = 1.0 // 1 second press
        longPressGesture.delegate = self as? UIGestureRecognizerDelegate
        calculatorTableView.addGestureRecognizer(longPressGesture)
        
    }
    
    // Changes the top Total: Profit, Loss and Margin values
    func changeTopTotalValues() {
        
        var totalProfitValue: Double = 0
        var totalLossValue: Double = 0
        var totalMarginValue: Double = 0
        
        // Iterate through positions array to get all values
        guard let arrayWithPositionsFromCoreData = controller.fetchedObjects else {
            return
        }
        for position in arrayWithPositionsFromCoreData {
            //---Back---
            if let profit = Double(position.getProfit()) {
                totalProfitValue += profit
            }
            if let loss = Double(position.getLoss()) {
                totalLossValue += loss
            }
            if let margin = Double(position.getMargin()) {
                totalMarginValue += margin
            }
            
        }
        
        // Update the Total Label's values
        totalProfitLabel.text = String(format: "%.2f", totalProfitValue)
        totalLossLabel.text = String(format: "%.2f", totalLossValue)
        totalMarginLabel.text = String(format: "%.2f", totalMarginValue)
        
    }
    
    //TODO: Make description
    @IBAction func backToCalculatorFromAddPositionWithoutSaving(sender: UIStoryboardSegue) {
        
    }
    
    //TODO: Make description
    @IBAction func backToCalculatorFromParamsSelectionPage(sender: UIStoryboardSegue) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateUILabelsWithLocalizedText()

        attemptFetch()
        updateTable()
        calculatorTableView.reloadData()
    }
    
}

extension CalculatorVC: NSFetchedResultsControllerDelegate {
    
    func attemptFetch() {
        
        let fetchRequest: NSFetchRequest<Position> = Position.fetchRequest()
        
        if let currentList = coreDataManager.getInstanceOfCurrentPositionsList() {
            fetchRequest.predicate = NSPredicate(format: "listOfPositions == %@", currentList)
        } else {
            fetchRequest.predicate = NSPredicate(format: "listOfPositions = nil")
        }
        
        let sortByPart1  = NSSortDescriptor(key: "instrument.part1", ascending: true)
        let sortByPart2  = NSSortDescriptor(key: "instrument.part2", ascending: true)
        let sortByPart3  = NSSortDescriptor(key: "takeProfit", ascending: true)
        fetchRequest.sortDescriptors = [sortByPart1, sortByPart2, sortByPart3]
        
        controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        
        do {
            try controller.performFetch()
        } catch {
            let error = error as NSError
            print("\(error)")
        }
    }
    
    func update(cell: CalculatorItemCell, indexPath: IndexPath) {
        
        let item = controller.object(at: indexPath)
        
        cell.updateCell(position: item)
        
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        calculatorTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        calculatorTableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                calculatorTableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                calculatorTableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .move:
            if let newIndexPath = newIndexPath, let indexPath = indexPath {
                calculatorTableView.moveRow(at: indexPath, to: newIndexPath)
            }
        case .update:
            if let indexPath = indexPath {
                let cell = calculatorTableView.cellForRow(at: indexPath) as! CalculatorItemCell
                update(cell: cell, indexPath: indexPath)
            }
        }
    }
    
}

extension CalculatorVC: UITableViewDelegate, UITableViewDataSource {
    
    func updateTable() {
        
        attemptFetch()
        
        if let currentListOfPositions = coreDataManager.getInstanceOfCurrentPositionsList() {
            currentListOfPositionsNameLabel.text = currentListOfPositions.listName
        } else {
            currentListOfPositionsNameLabel.text = "Choose or create a history list".localized()
        }
        
        changeTopTotalValues()
        
        calculatorTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sections = controller.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CalculatedPositionCell") as? CalculatorItemCell
            else { return UITableViewCell() }
        
        cell.cellIsOpen = false
        
        if let openedCell = openedCell, openedCell == indexPath.row {
            cell.cellIsOpen = true
        }
        
        cell.updateCell(position: controller.object(at: indexPath))
        
        return cell
    }
    
    func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        
        if longPressGestureRecognizer.state == UIGestureRecognizerState.began {
            
            let touchPoint = longPressGestureRecognizer.location(in: self.calculatorTableView)
            if let indexPath = calculatorTableView.indexPathForRow(at: touchPoint) {
                
                performAlertOnLongPressOnCellWith(indexPath)
            }
            
        }
    }
    
    func performAlertOnLongPressOnCellWith(_ indexPath: IndexPath) {
        
        let currentPosition = self.controller.object(at: indexPath)
        let positionName = currentPosition.instrument.name
        let longPressAlert = UIAlertController(title: nil, message: "\(positionName)", preferredStyle: .actionSheet)
        
        let titleForEditAction = "Edit position".localized()
        let editAction = UIAlertAction(title: titleForEditAction, style: .default) { (action) in
            
            self.performSegue(withIdentifier: "EditPosition", sender: currentPosition)
            
        }
        
        let titleForSavePosition = "Save all positions to history".localized()
        let savePositions = UIAlertAction(title: titleForSavePosition, style: .default) { (action) in
            
            self.performAlertForSavingAllPositionsToHistory()
            
        }
        
        let titleForDeleteAction = "Delete  position".localized()
        let deleteAction = UIAlertAction(title: titleForDeleteAction, style: .destructive) { (action) in
            
            self.context.delete(currentPosition)
            self.coreDataManager.saveContext()
            self.calculatorTableView.reloadData()
            
        }
        
        let titleForCancelAction = "Cancel".localized()
        let cancelAction = UIAlertAction(title: titleForCancelAction, style: .cancel, handler: nil)
        
        longPressAlert.addAction(editAction)
        longPressAlert.addAction(savePositions)
        longPressAlert.addAction(deleteAction)
        longPressAlert.addAction(cancelAction)
        
        self.present(longPressAlert, animated: true, completion: nil)
        
    }
    
    func performAlertForSavingAllPositionsToHistory() {
        
        let titleForSavePositionsAlert = "Save all positions to the list in history".localized()
        let savePositionsAlert = UIAlertController(title: titleForSavePositionsAlert, message: nil, preferredStyle: .alert)
        
        savePositionsAlert.addTextField(configurationHandler: { (textField) in
            
            if let listOfPositions = self.coreDataManager.getInstanceOfCurrentPositionsList() {
                textField.text = listOfPositions.listName
            } else {
                textField.text = ListOfPositions(needSave: false).listName
            }
            
        })
        
        let titleForConfirmAction = "save".localized()
        let confirmAction = UIAlertAction(title: titleForConfirmAction, style: .default, handler: { (_) in
            
            self.saveAllPositionToHistoryWith(savePositionsAlert)
            
        })
        
        savePositionsAlert.addAction(confirmAction)
        
        let titleForCancelAction = "cancel".localized()
        let cancelAction = UIAlertAction(title: titleForCancelAction, style: .cancel, handler: nil)
        
        savePositionsAlert.addAction(cancelAction)
        
        self.present(savePositionsAlert, animated: true, completion: nil)
        
    }
    
    func saveAllPositionToHistoryWith(_ savePositionsAlert: UIAlertController) {
        
        var listOfPositionsForSaving = ListOfPositions()
        let listNameFromTextField = savePositionsAlert.textFields![0].text!
        
        if let list = coreDataManager.getInstanceOfPositionListWith(listNameFromTextField) {
            listOfPositionsForSaving = list
            listOfPositionsForSaving.creationDate = NSDate()
        } else {
            listOfPositionsForSaving = ListOfPositions(needSave: true, listNameFromTextField, NSDate(), NSSet())
        }
        
        let positionsArray = self.controller.fetchedObjects!
        
        for position in positionsArray {
            position.listOfPositions = listOfPositionsForSaving
        }
        
        self.coreDataManager.saveContext()
        
        self.userDefaultsManager.currentListOfPositionsID = nil
        self.updateTable()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueID = segue.identifier
            else { return }
        
        switch segueID {
        case "chooseParamsAtFirstLaunch":
            
            guard let destination = segue.destination as? OptSelectParamsVC
                else { return }
            
            destination.doWeChooseParamsAtFirstLaunch = true
            
        case "EditPosition":
            guard let destination = segue.destination as? CalcAddItemVC
                else { return }
            guard let currentPosition = sender as? Position
                else { return }
            destination.positionToEdit = currentPosition
            
        default: break
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if openedCell == indexPath.row {
            openedCell = nil
        } else {
            openedCell = indexPath.row
        }
        
        tableView.reloadData()
        
    }
    
}














