//
//  CalendarEvent.swift
//  TradersCalculator
//
//  Created by Yaroslav Zhurbilo on 25.07.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

class CalendarEvent {
    
    fileprivate var _title: String!
    fileprivate var _currency: String!
    fileprivate var _importance: String!
//    fileprivate var _country: String!
//    fileprivate var _releaseDate: String!
//    fileprivate var _sourceOfReport: String!
//    fileprivate var _reportText: String!
//    fileprivate var _history: [CalendarEventHistory]!
    
    init(title: String, currency: String, importance: String) {
        self._title = title
        self._currency = currency
        self._importance = importance
    }
    
    convenience init() {
        self.init(title: "Test", currency: "USD", importance: "***")
    }
    
}
