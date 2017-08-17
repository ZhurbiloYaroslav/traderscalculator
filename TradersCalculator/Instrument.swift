//
//  Instrument.swift
//  TradersCalculator
//
//  Created by Yaroslav Zhurbilo on 19.07.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

//TODO: Write a description
class Instrument {
    
    private var _parts: [String]!
    private var _category: String!
    
    // This is a name of The instrument
    var name: String {
        
        var name = ""
        for instrumentPart in _parts {
            name += instrumentPart
        }
        
        return name
    }
    
    /* To delete
    //TODO: Write a description
    var instrumentString: String {
        
        if _parts != nil {
            
            var resultString = ""
            
            for part in _parts {
                resultString += part
            }
            
            return resultString
            
        } else {
            return ""
        }
        
    }
    */
    
    //TODO: Write a description
    var digitsAfterDot: Int {
        
        switch parts {
        case let x where x.contains("JPY"):
            return 3
        default:
            return 5
        }
        
    }
    
    //TODO: Write a description
    var parts: [String] {
        
        if _parts != nil {
            return _parts
        } else {
            return []
        }
        
    }
    
    //TODO: Write a description
    var category: String {
        
        if _category != nil {
            return _category
        } else {
            return ""
        }
        
    }
    
    //TODO: Write a description
    var countOfparts: Int {
        
        if _parts != nil {
            return self._parts.count
        } else {
            return 0
        }
    }
    
    //TODO: Write a description
    init(_ categoryName: String, _ instrumentParts: [String]) {
        
        self._parts = instrumentParts
        self._category = categoryName
        
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
        var saveCategory = ""
        var saveParts = [String]()
        
        if let categoryForSave = _category {
            saveCategory = categoryForSave
        }
        
        if let partsForSave = _parts {
            saveParts = partsForSave
        }
        
        // Make a adictionary with values for inserting to Firebase
        let instrumentDict: [String: Any] = [
            "parts": saveParts,
            "category": saveCategory
        ]
        
        return instrumentDict
        
    }
}








