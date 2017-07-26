//
//  CalendarCell.swift
//  TradersCalculator
//
//  Created by Yaroslav Zhurbilo on 25.07.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit

class CalendarCell: UITableViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var importanceLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var actualLabel: UILabel!
    @IBOutlet weak var consLabel: UILabel!
    @IBOutlet weak var previousLabel: UILabel!
    
    func updateCell() {
        
        self.timeLabel.text = "8:00"
        self.currencyLabel.text = "EUR"
        self.importanceLabel.text = "***"
        self.countryLabel.text = "Flag"
        self.titleLabel.text = "This is a title"
        self.actualLabel.text = "125.4"
        self.consLabel.text = "123.8"
        self.previousLabel.text = "124.2"
        
    }

}







