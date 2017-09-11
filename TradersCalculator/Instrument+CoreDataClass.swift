//
//  Instrument+CoreDataClass.swift
//  TradersCalculator
//
//  Created by Yaroslav Zhurbilo on 31.08.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation
import CoreData


public class Instrument: NSManagedObject {
    
    var parts: [String] {
        
        return [part1, part2]
        
    }
    
    // This is a name of The instrument
    var name: String {
        
        return concatenateParts()
        
    }
    
    func concatenateParts() -> String {
        
        var name = ""
        for instrumentPart in parts {
            name += instrumentPart
        }
        
        return name
        
    }
    
    //TODO: Write a description
    var digitsAfterDot: Int {
        
        switch parts {
        case let x where x.contains("JPY"):
            return 3
        default:
            return 5
        }
        
    }
    
    var countOfparts: Int {
        return self.parts.count
    }
    
    convenience init(needSave: Bool, _ categoryName: String, _ instrumentParts: [String]) {
        
        let coreDataManager = CoreDataManager()
        let instrument = NSEntityDescription.entity(forEntityName: "Instrument", in: coreDataManager.context)!
        
        if(needSave) {
            self.init(entity: instrument, insertInto: coreDataManager.context)
        } else {
            self.init(entity: instrument, insertInto: nil)
        }
        
        self.part1 = instrumentParts[0]
        self.part2 = instrumentParts[1]
        self.category = categoryName
        
    }
    
    convenience init() {
        self.init(needSave: false, Instruments().defaultCategory, Instruments().defaultInstrumentPair)
    }
}








