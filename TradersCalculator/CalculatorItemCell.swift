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
    @IBOutlet weak var openPriceLabel: UILabel!
    
    func updateCell(position: Position) {
        
        instrumentNameLabel.text = position.instrument
        dealDirectionLabel.text = position.dealDirection
        valueLabel.text = "\(position.value)"
        stopLossLabel.text = "\(position.stopLoss)"
        takeProfitLabel.text = "\(position.takeProfit)"
        openPriceLabel.text = "\(position.openPrice)"
        
        if position.dealDirection == "Buy" {
            dealDirectionLabel.textColor = UIColor.blue
            valueLabel.textColor = UIColor.blue
        } else {
            dealDirectionLabel.textColor = UIColor.red
            valueLabel.textColor = UIColor.red
        }
    }
    
    func populateValues() {
        var numberFormatter: NumberFormatter {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            return formatter
        }
        
        var currencyFormatter: NumberFormatter {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            return formatter
        }
        
        var dateFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .medium
            return formatter
        }
        
//        textLabel.text = "Good Morning"
//        numberLabel.text = numberFormatter.string(from: 9999999.999)
//        currencyLabel.text = currencyFormatter.string(from: 5000)
//        dateLabel.text = dateFormatter.string(from: NSDate() as Date)
//        imageView.image = UIImage(named: "adele-hello")
    }
    
}
