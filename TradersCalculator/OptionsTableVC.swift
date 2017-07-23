//
//  OptionsTableVC.swift
//  TradersCalculator
//
//  Created by Yaroslav Zhurbilo on 22.07.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit

class OptionsTableVC: UITableViewController {
    
    var currentUserOptions: CurrentUser!
    
    @IBOutlet weak var currencyCell: UITableViewCell!
    @IBOutlet weak var leverageCell: UITableViewCell!
    @IBOutlet weak var languageCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // User Options from User defaults
        currentUserOptions = CurrentUser()
        
        // Update current Table
        updateTable()
        
    }
    
    func updateTable() {
        
        currencyCell.detailTextLabel?.text = currentUserOptions.accountCurrency
        leverageCell.detailTextLabel?.text = currentUserOptions.leverage
        languageCell.detailTextLabel?.text = currentUserOptions.language
        
        tableView.reloadData()
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath {
        case [1,0]:
            performSegue(withIdentifier: "OptionsChangeLanguage", sender: nil)
        default:
            break
        }
        
    }
    
    //TODO: Make description
    @IBAction func backToOptionsFromParametersWithSaving(sender: UIStoryboardSegue) {
        updateTable()
    }
    
    
    //TODO: github.com/Ftkey/LTModalViewController
    //TODO: cocoapods.org/pods/JModalController
    //TODO: github.com/martinnormark/HalfModalPresentationController


}

// Methods that related to seagues
extension OptionsTableVC {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueIdentifier = segue.identifier
            else { return }
        
        switch segueIdentifier {
        case "OptionsChangeLanguage":
            guard let destination = segue.destination as? OptSelectParamsVC
                else { return }
            destination.doWeChooseLanguageNow = true
        default:
            break
        }
    }
    
}


