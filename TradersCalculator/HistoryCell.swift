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
    @IBOutlet weak var positionsLabel: UILabel!
    
    func updateCell(_ list: ListOfPositions) {
        
        self.listNameLabel.text = list.listName
        self.creationDateLabel.text = "\(list.creationDate)"
        self.positionsLabel.text = ""
        
        for position in list.position {
            if let position = position as? Position {
                self.positionsLabel.text = self.positionsLabel.text! + position.instrument.name + ", "
            }
            
        }
        
    }

}







