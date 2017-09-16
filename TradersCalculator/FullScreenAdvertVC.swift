//
//  FullScreenAdvertVC.swift
//  TraderCalculator
//
//  Created by Yaroslav Zhurbilo on 16.09.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit

class FullScreenAdvertVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)

    }
    
    func update() {
        performSegue(withIdentifier: "backToCalculatorFromFullScreenAdvert", sender: nil)
    }
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: "backToCalculatorFromFullScreenAdvert", sender: nil)
        
    }
    
    @IBAction func bannerPressed(_ sender: UIButton) {
        
        CustomBanner().showAdvertAfterBannerPressed()
        
    }

}
