//
//  GreetingsVC.swift
//  TraderCalculator
//
//  Created by Yaroslav Zhurbilo on 18.09.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit

class GreetingsVC: UIViewController {
    
    @IBOutlet weak var welcomeScreenText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUILabelsWithLocalizedText()
        
    }
    
    func updateUILabelsWithLocalizedText() {
        
        welcomeScreenText.text = "welcome screen text".localized()
        
    }
    
    @IBAction func greetingsNextButtonPressed(_ sender: UIButton) {
        showParamsViewToChooseParamsAtFirstLaunch()
    }
    
    func showParamsViewToChooseParamsAtFirstLaunch() {
        performSegue(withIdentifier: "chooseParamsAtFirstLaunch", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueID = segue.identifier
            else { return }
        
        switch segueID {
            
        case "chooseParamsAtFirstLaunch":
            
            guard let destination = segue.destination as? OptSelectParamsVC
                else { return }
            
            destination.doWeChooseParamsAtFirstLaunch = true
            
        default: break
        }
        
    }

}
