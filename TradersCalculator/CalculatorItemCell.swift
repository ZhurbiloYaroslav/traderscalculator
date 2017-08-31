//
//  CalculatorItemCell.swift
//  TradersCalculator
//
//  Created by Yaroslav Zhurbilo on 15.07.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit

class CalculatorItemCell: UITableViewCell {
    
    // Definition of the Labels and Stack views in the Cell in CalculatorVC.swift
    @IBOutlet weak var instrumentNameLabel: UILabel!
    @IBOutlet weak var dealDirectionLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!                // Label for value (Russian: Лот)
    
    @IBOutlet weak var stackForProfitTop: UIStackView!
    @IBOutlet weak var profitLabelTopRight: UILabel!
    
    @IBOutlet weak var valueBeforeArrow: UILabel!
    @IBOutlet weak var valueAfterArrow: UILabel!
    
    @IBOutlet weak var bottomHiddenStackWithValues: UIStackView!
    @IBOutlet weak var openPriceLabelBottomLeft: UILabel!
    @IBOutlet weak var takeProfitLabelBottomLeft: UILabel!
    @IBOutlet weak var stopLossLabelBottomLeft: UILabel!
    @IBOutlet weak var marginLabelBottomLeft: UILabel!
    
    @IBOutlet weak var profitLabelBottomRight: UILabel!
    @IBOutlet weak var lossLabelBottomRight: UILabel!
    @IBOutlet weak var marginLabelBottomRight: UILabel!
    
    // False if the cell is closed (bottom stack with values is hidden)
    // True if the cell is open (bottom stack with values is visible)
    var cellIsOpen = false
    
    // Make changes to the labels and views of the cell
    func updateCell(position: Position) {
        
        // Set the Label's values in the cell
        setLabelsValues(position: position)
        
        // Open or Close the cell
        if cellIsOpen {
            openCell()
        } else {
            closeCell()
        }
        
        // Change color of the labels
        if position.dealDirection == "Buy" {
            dealDirectionLabel.textColor = Constants.Color.blue
            valueLabel.textColor = Constants.Color.blue
        } else {
            dealDirectionLabel.textColor = Constants.Color.red
            valueLabel.textColor = Constants.Color.red
        }
    }
    
    // Set the Label's values in the cell
    func setLabelsValues(position: Position) {
        
        let formatString = "%.\(position.instrument.digitsAfterDot)f"
                
        instrumentNameLabel.text = position.instrument.name
        valueLabel.text = String(format: "%.2f", position.value)
        valueBeforeArrow.text = String(format: formatString, position.openPrice)
        valueAfterArrow.text = String(format: formatString, position.takeProfit)
        profitLabelTopRight.text = "\(position.getProfit())"
        
        openPriceLabelBottomLeft.text = String(format: formatString, position.openPrice)
        takeProfitLabelBottomLeft.text = String(format: formatString, position.takeProfit)
        stopLossLabelBottomLeft.text = String(format: formatString, position.stopLoss)
        marginLabelBottomLeft.text = position.getMargin()
        
        profitLabelBottomRight.text = position.getProfit()
        lossLabelBottomRight.text = position.getLoss()
        marginLabelBottomRight.text = "" // was: \(position.getMargin())
        
        // Determine, whether the Position is Sell or Buy
        if position.dealDirection == "Sell" {
            dealDirectionLabel.text = "sell"
        }
        if position.dealDirection == "Buy" {
            dealDirectionLabel.text = "buy"
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
        stackForProfitTop.isHidden = true
        bottomHiddenStackWithValues.isHidden = false
        
    }
    
    //TODO: Make comment
    func closeCell() {
        
        // stackWithArrow.isHidden = false
        stackForProfitTop.isHidden = false
        bottomHiddenStackWithValues.isHidden = true
        
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
