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
    @IBOutlet weak var listNameToolBarButton: UIBarButtonItem!
    
    @IBOutlet weak var containerConstraintToChange: NSLayoutConstraint!
    
    @IBOutlet weak var googleBannerView: GADBannerView!
    @IBOutlet weak var calculatorTableView: UITableView!
    
    var adMob: AdMob!
    var openedCell: Int?
    
    var freeOrPro: FreeOrProVersion!
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
    
    @IBAction func bannerPressed(_ sender: UIButton) {

        CustomBanner().showAdvertAfterBannerPressed()
        
    }
    
    func updateUILabelsWithLocalizedText() {

        
        
    }
    
    func initializeVariables() {
        
        freeOrPro = FreeOrProVersion(bannerView: googleBannerView,
                                            constraint: containerConstraintToChange,
                                            tableViewToChange: calculatorTableView)
        
        controller = NSFetchedResultsController<Position>()
        userDefaultsManager = UserDefaultsManager()
        coreDataManager = CoreDataManager()
        context = coreDataManager.context
        updateTable()
        
        if FirstLaunch.isFirstLaunched {
            chooseParamsAtFirstLaunch()
        }
        
        longTapOnCellRecognizerSetup()
        
        calculatorTableView.estimatedRowHeight = 100
        calculatorTableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    func chooseParamsAtFirstLaunch() {
        performSegue(withIdentifier: "chooseParamsAtFirstLaunch", sender: nil)
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
        let accountCurrency = userDefaultsManager.accountCurrency
        totalProfitLabel.text = String(format: "%.2f", totalProfitValue) + " \(accountCurrency)"
        totalLossLabel.text = String(format: "%.2f", totalLossValue) + " \(accountCurrency)"
        totalMarginLabel.text = String(format: "%.2f", totalMarginValue) + " \(accountCurrency)"
        
    }
    
    @IBAction func addListOfPositionsButtonPressed(_ sender: UIBarButtonItem) {
        
        self.performAlertForCreatingListOfPositions()
        
    }
    
    func performAlertForCreatingListOfPositions() {
        
        let titleForSavePositionsAlert = "Create an empty list".localized()
        let createListAlert = UIAlertController(title: titleForSavePositionsAlert, message: nil, preferredStyle: .alert)
        
        createListAlert.addTextField(configurationHandler: { (textField) in
            
            textField.text = ListOfPositions(needSave: false).listName
            
        })
        
        let titleForSaveAndClearAction = "save & clear".localized()
        let saveAndClearAction = UIAlertAction(title: titleForSaveAndClearAction, style: .default, handler: { (_) in
            
            self.addNewListOfPositions(createListAlert, andOpenIt: false)
            
        })
        
        let titleForSaveAndOpenAction = "save & open".localized()
        let saveAndOpenAction = UIAlertAction(title: titleForSaveAndOpenAction, style: .default, handler: { (_) in
            
            self.addNewListOfPositions(createListAlert, andOpenIt: true)
            
        })
        
        let titleForCancelAction = "cancel".localized()
        let cancelAction = UIAlertAction(title: titleForCancelAction, style: .cancel, handler: nil)
        
        
        createListAlert.addAction(saveAndClearAction)
        createListAlert.addAction(saveAndOpenAction)
        createListAlert.addAction(cancelAction)
        
        self.present(createListAlert, animated: true, completion: nil)
        
    }
    
    func addNewListOfPositions(_ createListAlert: UIAlertController, andOpenIt: Bool) {
        
        var newListOfPositions: ListOfPositions!
        let listNameFromTextField = createListAlert.textFields![0].text!
        
        if freeOrPro.canWeAddMoreRecordsWithType(type: .ListOfPositions) == false {
            simpleAlertWithTitle("Buy PRO to add more records".localized(),
                                 andMessage: nil)
            return
        }
        
        if coreDataManager.thereIsNoListWithSimilarName(listNameFromTextField) {
            
            newListOfPositions = ListOfPositions(needSave: true, listNameFromTextField, NSDate(), NSSet())
            self.coreDataManager.saveContext()
            
            if andOpenIt {
                self.userDefaultsManager.currentListOfPositionsID = newListOfPositions.objectID.uriRepresentation()
            } else {
                self.userDefaultsManager.currentListOfPositionsID = nil
            }
            
            self.updateTable()
            
        } else {
            
            self.simpleAlertWithTitle("The list with such name exists".localized(),
                                      andMessage: nil)
            return
        }
        
    }
    @IBAction func AddPositionButtonPressed(_ sender: UIButton) {
        
        if freeOrPro.canWeAddMoreRecordsWithType(type: .Position) == false {
            simpleAlertWithTitle("Buy PRO to add more records".localized(),
                                 andMessage: nil)
            return
        }
        
        performSegue(withIdentifier: "AddPositionButtonPressed", sender: nil)
        
    }
    
    @IBAction func addPositionsToTheListButtonPressed(_ sender: UIBarButtonItem) {
        
        self.performAlertForSavingAllPositionsToHistory()

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
        
        let titleForSaveAndClearAction = "save & clear".localized()
        let saveAndClearAction = UIAlertAction(title: titleForSaveAndClearAction, style: .default, handler: { (_) in
            
            self.saveAllPositionToHistoryWith(savePositionsAlert, andOpenIt: false)
            
        })
        
        let titleForSaveAndOpenAction = "save & open".localized()
        let saveAndOpenAction = UIAlertAction(title: titleForSaveAndOpenAction, style: .default, handler: { (_) in
            
            self.saveAllPositionToHistoryWith(savePositionsAlert, andOpenIt: true)
            
        })
        
        savePositionsAlert.addAction(saveAndClearAction)
        savePositionsAlert.addAction(saveAndOpenAction)
        
        let titleForCancelAction = "cancel".localized()
        let cancelAction = UIAlertAction(title: titleForCancelAction, style: .cancel, handler: nil)
        
        savePositionsAlert.addAction(cancelAction)
        
        self.present(savePositionsAlert, animated: true, completion: nil)
        
    }
    
    func saveAllPositionToHistoryWith(_ savePositionsAlert: UIAlertController, andOpenIt: Bool) {
        
        var listOfPositionsForSaving: ListOfPositions!
        let listNameFromTextField = savePositionsAlert.textFields![0].text!
        
        
        if freeOrPro.canWeAddMoreRecordsWithType(type: .ListOfPositions) == false {
            simpleAlertWithTitle("Buy PRO to add more records".localized(),
                                 andMessage: nil)
            return
        }
        
        if coreDataManager.thereIsNoListWithSimilarName(listNameFromTextField) {
            
            listOfPositionsForSaving = ListOfPositions(needSave: true, listNameFromTextField, NSDate(), NSSet())
            
        } else {
            
            self.simpleAlertWithTitle("The list with such name exists".localized(),
                                      andMessage: nil)
            return
            
        }
        
        let positionsArray = self.controller.fetchedObjects!
        
        for position in positionsArray {
            position.listOfPositions = listOfPositionsForSaving
        }
        
        self.coreDataManager.saveContext()
        
        if andOpenIt {
            self.userDefaultsManager.currentListOfPositionsID = listOfPositionsForSaving.objectID.uriRepresentation()
        } else {
            self.userDefaultsManager.currentListOfPositionsID = nil
        }
        
        self.updateTable()
        
    }
    
    func simpleAlertWithTitle(_ alertTitle: String, andMessage: String?) {
        
        let newAlert = UIAlertController(title: alertTitle, message: andMessage, preferredStyle: .alert)
        
        let titleForOkAction = "ok".localized()
        let okAction = UIAlertAction(title: titleForOkAction, style: .cancel, handler: nil)
        
        newAlert.addAction(okAction)
        
        self.present(newAlert, animated: true, completion: nil)
        
    }
    
    @IBAction func clearListOfPositionsAndCurrentList(_ sender: UIBarButtonItem) {
        
        UserDefaultsManager().currentListOfPositionsID = nil
        updateTable()

    }
    
    @IBAction func backToCalculatorFromAddPositionWithoutSaving(sender: UIStoryboardSegue) {
        
    }
    
    @IBAction func backToCalculatorFromParamsSelectionPage(sender: UIStoryboardSegue) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        freeOrPro.removeAdIfPRO()
        
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
        
        updateListButtonTitleAndState()
        
        changeTopTotalValues()
        
        calculatorTableView.reloadData()
    }
    
    func updateListButtonTitleAndState() {
        
        if let currentListOfPositions = coreDataManager.getInstanceOfCurrentPositionsList() {
            
            listNameToolBarButton.title = currentListOfPositions.listName
            listNameToolBarButton.isEnabled = false
            listNameToolBarButton.tintColor = UIColor.black
            
        } else if let positions = controller.fetchedObjects, positions.count == 0 {
            
            listNameToolBarButton.title = "Choose or create a list".localized()
            listNameToolBarButton.isEnabled = false
            listNameToolBarButton.tintColor = UIColor.black
            
        } else if let positions = controller.fetchedObjects, positions.count > 0 {
            
            listNameToolBarButton.title = "Save positions to the list".localized()
            listNameToolBarButton.isEnabled = true
            listNameToolBarButton.tintColor = Constants.Color.blue
            
        }
        
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
        
        let titleForMovePosition = "Move this position to list".localized()
        _ = UIAlertAction(title: titleForMovePosition, style: .default) { (action) in
            
            //TODO: Write fuction for moving selected position
            
        }
        
        let titleForDeleteAction = "Delete  position".localized()
        let deleteAction = UIAlertAction(title: titleForDeleteAction, style: .destructive) { (action) in
            
            self.context.delete(currentPosition)
            self.coreDataManager.saveContext()
            self.updateTable()
            
        }
        
        let titleForCancelAction = "Cancel".localized()
        let cancelAction = UIAlertAction(title: titleForCancelAction, style: .cancel, handler: nil)
        
        longPressAlert.addAction(editAction)
        longPressAlert.addAction(deleteAction)
        longPressAlert.addAction(cancelAction)
        
        self.present(longPressAlert, animated: true, completion: nil)
        
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














