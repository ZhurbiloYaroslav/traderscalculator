//
//  HistoryCell.swift
//  TradersCalculator
//
//  Created by Yaroslav Zhurbilo on 25.07.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {
    
    @IBOutlet weak var listNameLabel: UILabel!
    @IBOutlet weak var creationDateLabel: UILabel!
    
    @IBOutlet weak var bottomHiddenStackWithPositions: UIStackView!
    @IBOutlet weak var positionsLabel: UILabel!
    
    // False if the cell is closed (bottom stack with values is hidden)
    // True if the cell is open (bottom stack with values is visible)
    var cellIsOpen = false
    
    func updateCell(_ list: ListOfPositions) {
        
        setLabelsValues(list)
        
        // Open or Close the cell
        if cellIsOpen {
            openCell()
        } else {
            closeCell()
        }
        
    }
    
    func setLabelsValues(_ list: ListOfPositions) {
        
        self.listNameLabel.text = list.listName
        self.creationDateLabel.text = getFormatted(date: list.creationDate)
        self.positionsLabel.text = ""
        
        for position in list.position {
            
            if let position = position as? Position {
                self.positionsLabel.text = self.positionsLabel.text! + position.instrument.name + " "
                self.positionsLabel.text = self.positionsLabel.text! + position.dealDirection + " "
                self.positionsLabel.text = self.positionsLabel.text! + "\(position.value)" + "\n"
                self.positionsLabel.text = self.positionsLabel.text! + "\(position.openPrice)" + " -> "
                self.positionsLabel.text = self.positionsLabel.text! + "\(position.takeProfit)" + "\n"
            }
            
        }
        
    }
    
    func openCell() {
        
        bottomHiddenStackWithPositions.isHidden = false
        
    }
    
    func closeCell() {
        
        bottomHiddenStackWithPositions.isHidden = true
        
    }
    
    func getFormatted(date: NSDate) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm"
        let dateString = dateFormatter.string(from: date as Date)
        return dateString
        
    }

}







