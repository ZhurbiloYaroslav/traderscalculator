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
import MessageUI

class HistoryVC: UIViewController {
    
    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak var googleBannerView: GADBannerView!
    
    @IBOutlet weak var containerConstraintToChange: NSLayoutConstraint!
    
    var adMob: AdMob!
    var openedCell: Int?
    var arrayWithListOfPositions: [ListOfPositions]!
    
    var freeOrProVersion: FreeOrProVersion!
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
        
        freeOrProVersion = FreeOrProVersion(bannerView: googleBannerView,
                                            constraint: containerConstraintToChange,
                                            tableViewToChange: historyTableView)
        
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
        
        freeOrProVersion.removeAdIfPRO()
        
        updateUILabelsWithLocalizedText()
        
        historyTableView.reloadData()
    }
    
    @IBAction func exportButtonPressed(_ sender: UIBarButtonItem) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
}

extension HistoryVC: MFMailComposeViewControllerDelegate {
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients(["5814611@gmail.com"])
        mailComposerVC.setSubject("Export of the history")
        
        let dataForExport = getCsvDataForExportHistory()
        mailComposerVC.addAttachmentData(dataForExport, mimeType: "text/csv", fileName: "ExportedHistory.csv")
        
        mailComposerVC.setMessageBody("Export of the history is in attachments", isHTML: false)
        
        return mailComposerVC
        
    }
    
    func getCsvDataForExportHistory() -> Data {
        
        var csvText = ""
        
        var headerOfCsvFile = ""
        headerOfCsvFile += getWrappedString("export date".localized(), withDelimiter: true)
        headerOfCsvFile += getWrappedString("list date".localized(), withDelimiter: true)
        headerOfCsvFile += getWrappedString("list name".localized(), withDelimiter: true)
        
        headerOfCsvFile += getWrappedString("instrument name".localized(), withDelimiter: true)
        headerOfCsvFile += getWrappedString("value".localized(), withDelimiter: true)
        headerOfCsvFile += getWrappedString("open price".localized(), withDelimiter: true)
        headerOfCsvFile += getWrappedString("take profit".localized(), withDelimiter: true)
        headerOfCsvFile += getWrappedString("stop loss".localized(), withDelimiter: true)
        headerOfCsvFile += getWrappedString("profit".localized(), withDelimiter: true)
        headerOfCsvFile += getWrappedString("loss".localized(), withDelimiter: true)
        headerOfCsvFile += getWrappedString("margin".localized(), withEndOfLine: true)
        
        csvText += headerOfCsvFile
        
        if let listOfPositionsArray = controller.fetchedObjects {
            for list in listOfPositionsArray {
                
                for _position in list.position {
                    
                    let position = _position as! Position
                    let creationDate = position.listOfPositions?.creationDate ?? NSDate()
                    let listName = position.listOfPositions?.listName ?? ""
                    
                    var newLine = ""
                    newLine += getWrappedString(Formatter.getFormatted(date: NSDate()), withDelimiter: true)
                    newLine += getWrappedString(Formatter.getFormatted(date: creationDate), withDelimiter: true)
                    newLine += getWrappedString(listName, withDelimiter: true)
                    newLine += getWrappedString(position.instrument.name, withDelimiter: true)
                    newLine += getWrappedStringFromDouble(position.value, withDelimiter: true)
                    newLine += getWrappedStringFromDouble(position.openPrice, withDelimiter: true)
                    newLine += getWrappedStringFromDouble(position.takeProfit, withDelimiter: true)
                    newLine += getWrappedStringFromDouble(position.stopLoss, withDelimiter: true)
                    newLine += getWrappedString(position.getProfit(), withDelimiter: true)
                    newLine += getWrappedString(position.getLoss(), withDelimiter: true)
                    newLine += getWrappedString(position.getMargin(), withEndOfLine: true)
                    
                    csvText.append(newLine)
                }
            }
        }
        
        print(csvText)
        
        if let csvData = csvText.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            return csvData
        } else {
            return Data()
        }
        
    }
    
    func getWrappedString(_ string: String, withDelimiter: Bool = false, withEndOfLine: Bool = false) -> String {
        
        let delimiter = ","
        let endOfLine = "\n"
        
        var result = "\"" + string + "\""
        result += withDelimiter ? delimiter : ""
        result += withEndOfLine ? endOfLine : ""
        return result
    }
    
    func getWrappedStringFromDouble(_ double: Double, withDelimiter: Bool = false, withEndOfLine: Bool = false) -> String {
        let stringFromDouble = String(describing: double)
        return getWrappedString(stringFromDouble, withDelimiter: withDelimiter, withEndOfLine: withEndOfLine)
    }

    
    func showSendMailErrorAlert() {
        
        let alertTitle = "Could Not Send Email".localized()
        let alertMessage = "Your device could not send e-mail. Please check e-mail configuration and try again".localized()
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        let okActionTitle = "OK"
        let okAction = UIAlertAction(title: okActionTitle, style: .default, handler: nil)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        
    }
    
}

extension HistoryVC: NSFetchedResultsControllerDelegate {
    
    func attemptFetch() {
        
        let fetchRequest: NSFetchRequest<ListOfPositions> = ListOfPositions.fetchRequest()
        let sortDescriptor  = NSSortDescriptor(key: "creationDate", ascending: false)
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
        
        let editedListOfPositions = controller.object(at: indexPath)
        let listName = editedListOfPositions.listName
        let alert = UIAlertController(title: nil, message: "\(listName)", preferredStyle: .actionSheet)
        
        let titleForOpenAction = "Open".localized()
        let openAction = UIAlertAction(title: titleForOpenAction, style: .default) { (action) in
            
            let currentListIdURL = editedListOfPositions.objectID.uriRepresentation()
            UserDefaultsManager().currentListOfPositionsID = currentListIdURL
            
            self.tabBarController?.selectedIndex = 0
            
        }
        
        let titleForCopyAction = "Copy".localized()
        let copyAction = UIAlertAction(title: titleForCopyAction, style: .default) { (action) in
            
            self.performAlertForCopyOfTheListOfPositions(editedListOfPositions)
            
        }
        
        let titleForEditAction = "Edit name".localized()
        let editAction = UIAlertAction(title: titleForEditAction, style: .default) { (action) in
            
            let titleForEditNameAlert = "Edit name of the history".localized()
            let editNameAlert = UIAlertController(title: titleForEditNameAlert, message: nil, preferredStyle: .alert)
            
            editNameAlert.addTextField(configurationHandler: { (textField) in
                textField.text = editedListOfPositions.listName
            })
            
            let titleForConfirmAction = "save".localized()
            let confirmAction = UIAlertAction(title: titleForConfirmAction, style: .default, handler: { (_) in
                
                let textField = editNameAlert.textFields![0]
                if let listNameFromTextField = textField.text {
                    
                    self.updateTitleForListOfPositions(newTitle: listNameFromTextField,
                                                  editedListOfPositions: editedListOfPositions)
                    
                }
                
            })
            
            let titleForCancelAction = "cancel".localized()
            let cancelAction = UIAlertAction(title: titleForCancelAction, style: .cancel, handler: nil)
            
            editNameAlert.addAction(confirmAction)
            editNameAlert.addAction(cancelAction)
            
            self.present(editNameAlert, animated: true, completion: nil)
            
        }
        
        let titleForExportAction = "Export".localized()
        let exportAction = UIAlertAction(title: titleForExportAction, style: .default) { (action) in
            
            //TODO:
            
        }
        
        let titleForDeleteAction = "Delete".localized()
        let deleteAction = UIAlertAction(title: titleForDeleteAction, style: .destructive) { (action) in
            
            self.context.delete(editedListOfPositions)
            self.coreDataManager.saveContext()
            self.userDefaultsManager.currentListOfPositionsID = nil
            
        }
        
        let titleForCancelAction = "Cancel".localized()
        let cancelAction = UIAlertAction(title: titleForCancelAction, style: .cancel, handler: nil)
        
        alert.addAction(openAction)
        alert.addAction(copyAction)
        alert.addAction(editAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func updateTitleForListOfPositions(newTitle: String, editedListOfPositions: ListOfPositions) {
        if self.coreDataManager.getInstanceOfPositionListWith(newTitle) == nil {
            
            editedListOfPositions.listName = newTitle
            
            self.coreDataManager.saveContext()
            
        } else {
            
            let newAlertTitle = "This name of the list exist".localized()
            let newAlert = UIAlertController(title: newAlertTitle, message: nil, preferredStyle: .alert)
            
            let titleForOkAction = "ok".localized()
            let okAction = UIAlertAction(title: titleForOkAction, style: .cancel, handler: nil)
            
            newAlert.addAction(okAction)
            
            self.present(newAlert, animated: true, completion: nil)
            
        }
    }
    
    func performAlertForCopyOfTheListOfPositions(_ editedListOfPositions: ListOfPositions) {
        
        let titleForSavePositionsAlert = "Make dublicate of the list with positions".localized()
        let savePositionsAlert = UIAlertController(title: titleForSavePositionsAlert, message: nil, preferredStyle: .alert)
        
        savePositionsAlert.addTextField(configurationHandler: { (textField) in
            
            textField.text = ListOfPositions(needSave: false).listName
            
        })
        
        let titleForConfirmAction = "save".localized()
        let confirmAction = UIAlertAction(title: titleForConfirmAction, style: .default, handler: { (_) in
            
            self.makeDublicateOfTheListOfPositions(editedListOfPositions, withAlert: savePositionsAlert)
            
        })
        
        savePositionsAlert.addAction(confirmAction)
        
        let titleForCancelAction = "cancel".localized()
        let cancelAction = UIAlertAction(title: titleForCancelAction, style: .cancel, handler: nil)
        
        savePositionsAlert.addAction(cancelAction)
        
        self.present(savePositionsAlert, animated: true, completion: nil)
        
    }
    
    func makeDublicateOfTheListOfPositions(_ editedListOfPositions: ListOfPositions, withAlert savePositionsAlert: UIAlertController) {
        
        let listNameFromTextField = savePositionsAlert.textFields![0].text!
        let listOfPositionsForSaving = ListOfPositions(needSave: true, listNameFromTextField, NSDate(), NSSet())
        coreDataManager.saveContext()
        
        let positionsArray = coreDataManager.getPositionsForList(editedListOfPositions)
        
        for position in positionsArray {
            let categoryNameOfInstrument = position.instrument.category
            let partsOfInstrument = position.instrument.parts
            let newInstrument = Instrument(needSave: true, categoryNameOfInstrument, partsOfInstrument)
            
            let newPosition = Position(needSave: true,
                                       creationDate: NSDate(),
                                       instrument: newInstrument,
                                       value: position.value,
                                       openPrice: position.openPrice,
                                       stopLoss: position.stopLoss,
                                       takeProfit: position.takeProfit,
                                       dealDirection: position.dealDirection)
            
            newPosition.listOfPositions = listOfPositionsForSaving
            
        }
        
        self.coreDataManager.saveContext()
        
        self.historyTableView.reloadData()
        
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




