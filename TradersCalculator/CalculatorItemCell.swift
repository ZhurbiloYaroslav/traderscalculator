//
//  CalculatorItemCell.swift
//  TradersCalculator
//
//  Created by Yaroslav Zhurbilo on 15.07.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit

class CalculatorItemCell: UITableViewCell {
    
    @IBOutlet weak var instrumentNameLabel: UILabel!
    @IBOutlet weak var dealDirectionLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!       // Label for value (Russian: Лот)
    @IBOutlet weak var takeProfitLabel: UILabel!
    @IBOutlet weak var stopLossLabel: UILabel!
    
    func updateCell(position: Position) {
        
        instrumentNameLabel.text = position.instrument
        dealDirectionLabel.text = position.dealDirection
        valueLabel.text = "\(position.value)"
        stopLossLabel.text = "\(position.stopLoss)"
        takeProfitLabel.text = "\(position.takeProfit)"
        
        if position.dealDirection == "Buy" {
            dealDirectionLabel.textColor = UIColor.blue
        } else {
            dealDirectionLabel.textColor = UIColor.red
        }
    }
    
}
