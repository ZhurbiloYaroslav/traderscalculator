//
//  Instrument+CoreDataProperties.swift
//  TradersCalculator
//
//  Created by Yaroslav Zhurbilo on 30.08.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation
import CoreData


extension Instrument {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Instrument> {
        return NSFetchRequest<Instrument>(entityName: "Instrument")
    }

    @NSManaged public var category: String
    @NSManaged public var part1: String
    @NSManaged public var part2: String
    @NSManaged public var position: Position

}
