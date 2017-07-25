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
    @IBOutlet weak var blueLabel: UILabel!
    
    @IBOutlet weak var valueBeforeArrow: UILabel!
    @IBOutlet weak var valueAfterArrow: UILabel!
    @IBOutlet weak var stackWithArrow: UIStackView!
    @IBOutlet weak var hiddenStackWithValues: UIStackView!
    @IBOutlet weak var blueLabelStack: UIStackView!
    
    //TODO: Make comment
    var cellIsOpen = false
    
    //TODO: Make comment
    func updateCell(position: Position) {
        
        instrumentNameLabel.text = position.instrument
        valueLabel.text = "\(position.value)"
        stopLossLabel.text = "\(position.stopLoss)"
        takeProfitLabel.text = "\(position.takeProfit)"
        openPriceLabel.text = "\(position.openPrice)"
        valueBeforeArrow.text = "\(position.openPrice)"
        valueAfterArrow.text = "\(position.takeProfit)"
        
        //TODO: Make comment
        if position.dealDirection == "Sell" {
            dealDirectionLabel.text = "sell"
        }
        if position.dealDirection == "Buy" {
            dealDirectionLabel.text = "buy"
        }
        
        //TODO: Make comment
        if cellIsOpen {
            openCell()
        } else {
            closeCell()
        }
        
        //TODO: Make comment
        if position.dealDirection == "Buy" {
            dealDirectionLabel.textColor = UIColor.blue
            valueLabel.textColor = UIColor.blue
        } else {
            dealDirectionLabel.textColor = UIColor.red
            valueLabel.textColor = UIColor.red
        }
    }
    
    //TODO: Implement this method
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //TODO: Make comment
    func openCell() {
        
        // stackWithArrow.isHidden = true
        blueLabelStack.isHidden = true
        hiddenStackWithValues.isHidden = false
        
    }
    
    //TODO: Make comment
    func closeCell() {
        
        // stackWithArrow.isHidden = false
        blueLabelStack.isHidden = false
        hiddenStackWithValues.isHidden = true
        
    }
    
    //TODO: Make comment
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
