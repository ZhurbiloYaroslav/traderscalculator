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
    
    @IBOutlet weak var googleBannerView: GADBannerView!
    @IBOutlet weak var calculatorTableView: UITableView!
    
    var adMob: AdMob!
    var positionsArray = [Position]()
    var positionsArrayByID: [NSManagedObjectID: Position]!
    var openedPositionCell: Int?
    
    var coreDataManager: CoreDataManager!
    var context: NSManagedObjectContext!
    var controller: NSFetchedResultsController<Position>!
    
    @IBAction func testButton(_ sender: UIButton) {
        
        updateTable()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initDelegates()
        
        initializeVariables()
        
        adMob = AdMob()
        adMob.getLittleBannerFor(viewController: self, adBannerView: googleBannerView)
        
        attemptFetch()
        
    }
    
    func initializeVariables() {
        
        controller = NSFetchedResultsController<Position>()
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
    
    func getCurrentDate() -> String {
        
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateString = dateFormatter.string(from: date as Date)
        return dateString
        
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
        for position in positionsArray {
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
    
}

extension CalculatorVC: NSFetchedResultsControllerDelegate {
    
    func attemptFetch() {
        
        guard let currentList = coreDataManager.getInstanceOfCurrentPositionsList() else {
            return
        }
        
        let fetchRequest: NSFetchRequest<Position> = Position.fetchRequest()
        let dateSort  = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.predicate = NSPredicate(format: "listOfPositions.listName == %@", currentList.listName)
        fetchRequest.sortDescriptors = [dateSort]
        
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

// Table view delegates and methods
extension CalculatorVC: UITableViewDelegate, UITableViewDataSource {
    
    func updateTable() {
        
        positionsArray = [Position]()
        positionsArrayByID = [NSManagedObjectID: Position]()
        
        positionsArray = coreDataManager.getPositionsForCurrentList()
        
        for position in positionsArray {
            positionsArrayByID.updateValue(position, forKey: position.objectID)
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
        
        if let openedCell = openedPositionCell, openedCell == indexPath.row {
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
        
        let currentPosition = positionsArray[indexPath.row]
        let positionName = currentPosition.instrument.name
        let alert = UIAlertController(title: nil, message: "\(positionName)", preferredStyle: .actionSheet)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            print("---started deleting")
            let deletingPosition = self.controller.object(at: indexPath)
            print("---instr", deletingPosition.instrument.name)
            let deletingPositionID = deletingPosition.objectID
            self.context.delete(deletingPosition)
            self.positionsArray.remove(at: indexPath.row)
            self.positionsArrayByID.removeValue(forKey: deletingPositionID)
            print("---ended deleting")
            self.calculatorTableView.reloadData()
            
        }
        
        let EditAction = UIAlertAction(title: "Edit", style: .default) { (action) in
            
            self.performSegue(withIdentifier: "EditPosition", sender: currentPosition)
            
        }
        
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(DeleteAction)
        alert.addAction(EditAction)
        alert.addAction(CancelAction)
        
        self.present(alert, animated: true, completion: nil)
        
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
    
    //TODO: Make description
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        openedPositionCell = indexPath.row
        
        tableView.reloadData()
        
    }
    
}














