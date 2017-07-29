//
//  LastUsedInstrument.swift
//  TradersCalculator
//
//  Created by Yaroslav Zhurbilo on 28.07.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

struct LastUsedInstrument {
    
    var categoryID: Int!
    var instrumentLeftPartID: Int!
    var instrumentRightPartID: Int!
    
    init(categoryID: Int, leftPartID: Int, rightPartID: Int) {
        self.categoryID = categoryID
        self.instrumentLeftPartID = leftPartID
        self.instrumentRightPartID = rightPartID
    }
    
    init() {
        self.init(categoryID: 0, leftPartID: 0, rightPartID: 0)
    }
    
    init(data: [String: Int]) {
        
        var categoryID = 0
        var instrumentLeftPartID = 0
        var instrumentRightPartID = 0
        
        if data["categoryID"] != nil {
            categoryID = data["categoryID"]!
        }
        
        if data["instrumentLeftPartID"] != nil {
            instrumentLeftPartID = data["instrumentLeftPartID"]!
        }
        if data["instrumentRightPartID"] != nil {
            instrumentRightPartID = data["instrumentRightPartID"]!
        }
        
        self.init(categoryID: categoryID, leftPartID: instrumentLeftPartID, rightPartID: instrumentRightPartID)
    }
    
    func getDictForSave() -> Dictionary<String, Int> {
        return [
            "categoryID" : categoryID,
            "instrumentLeftPartID" : instrumentLeftPartID,
            "instrumentRightPartID" : instrumentRightPartID
        ]
    }
    
}








