//
//  TabBarController.swift
//  TradersCalculator
//
//  Created by Yaroslav Zhurbilo on 11.09.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUILabelsWithLocalizedText()
        
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        updateUILabelsWithLocalizedText()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateUILabelsWithLocalizedText()
    }
    
    func updateUILabelsWithLocalizedText() {
        
        tabBar.items?[0].title = "Calculator".localized()
        tabBar.items?[1].title = "History".localized()
        tabBar.items?[2].title = "Options".localized()
        
    }
    

}
