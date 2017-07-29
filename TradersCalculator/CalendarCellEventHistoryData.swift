//
//  CalendarCellEventHistoryData.swift
//  TradersCalculator
//
//  Created by Yaroslav Zhurbilo on 26.07.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit

class CalendarCellEventHistoryData: UITableViewCell {
    
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var actualLabel: UILabel!
    @IBOutlet weak var forecastLabel: UILabel!
    @IBOutlet weak var previousLabel: UILabel!
    
    func updateCell(_ values: [String: String]) {
        
        if let releaseDate = values["Release Date"] {
            releaseDateLabel.text = releaseDate
        }
        
        if let actual = values["Actual"] {
            actualLabel.text = actual
        }
        
        if let forecast = values["Forecast"] {
            forecastLabel.text = forecast
        }
        
        if let previous = values["Previous"] {
            previousLabel.text = previous
        }
        
        
        //TODO: Make comment
        actualLabel.textColor = UIColor.green
        previousLabel.textColor = UIColor.red
        
    }
    
}
