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
    
    convenience init(_ categoryName: String, _ instrumentParts: [String]) {
        
        let coreDataManager = CoreDataManager()
        let instrument = NSEntityDescription.entity(forEntityName: "Instrument", in: coreDataManager.context)!
        self.init(entity: instrument, insertInto: coreDataManager.context)
        self.part1 = instrumentParts[0]
        self.part2 = ""
        self.category = categoryName
        
    }
    
    convenience init() {
        self.init(Instruments().defaultCategory, Instruments().defaultInstrumentPair)
    }
    
    // Makes an Instrument from dictionary with values from the Firebase
    convenience init(firebaseDict: [String: Any]) {
        var saveCategory = Instruments().defaultCategory
        var saveParts = Instruments().defaultInstrumentPair
        
        if let instrumentCategory = firebaseDict["category"] as? String {
            saveCategory = instrumentCategory
        }
        
        if let instrumentParts = firebaseDict["parts"] as? [String] {
            saveParts = instrumentParts
        }
        
        self.init(saveCategory, saveParts)
        
    }
    
    // Returns a dictionary with Instrument values for saving to the Firebase
    func getDictForSavingToFirebase() -> [String: Any] {
        
        // Make a adictionary with values for inserting to Firebase
        let instrumentDict: [String: Any] = [
            "parts": parts,
            "category": category
        ]
        
        return instrumentDict
        
    }
}








