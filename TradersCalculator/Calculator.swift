//
//  Calculator.swift
//  TradersCalculator
//
//  Created by Yaroslav Zhurbilo on 01.08.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//S

import Foundation

class Calculator {
    
    private var position: Position!
    private var formulas: Formulas!
    
    init(position: Position) {
        self.position = position
        self.formulas = Formulas(position: position)
    }
    
    func getProfit() -> Double {
        
        switch position.instrument.name {
            
        case let x where FormulaOption().localUSD.contains(x):
            return formulas.profit1_LocalUSD()
            
        case let x where FormulaOption().USDLocal.contains(x):
            return formulas.profit2_USDLocal()
            
        case let x where FormulaOption().crossCur1.contains(x):
            return formulas.profit3_CrossCur1()
            
        case let x where FormulaOption().crossCur2.contains(x):
            return formulas.profit4_CrossCur2()
            
        case let x where FormulaOption().crossCur3.contains(x):
            return formulas.profit5_CrossCur3()
            
        default:
            return 0
        }
        
    }
    
    func getLoss() -> Double {
        
        switch position.instrument.name {
            
        case let x where FormulaOption().localUSD.contains(x):
            return formulas.loss1_LocalUSD()
            
        case let x where FormulaOption().USDLocal.contains(x):
            return formulas.loss2_USDLocal()
            
        case let x where FormulaOption().crossCur1.contains(x):
            return formulas.loss3_CrossCur1()
            
        case let x where FormulaOption().crossCur2.contains(x):
            return formulas.loss4_CrossCur2()
            
        case let x where FormulaOption().crossCur3.contains(x):
            return formulas.loss5_CrossCur3()
            
        default:
            return 0
        }
        
    }
    
    func getMargin() -> Double {
        
        switch position.instrument.name {
            
        case let x where FormulaOption().localUSD.contains(x):
            return formulas.margin1_LocalUSD()
            
        case let x where FormulaOption().USDLocal.contains(x):
            return formulas.margin2_USDLocal()
            
        case let x where FormulaOption().crossCur1.contains(x):
            return formulas.margin3_CrossCur1()
            
        case let x where FormulaOption().crossCur2.contains(x):
            return formulas.margin4_CrossCur2()
            
        case let x where FormulaOption().crossCur3.contains(x):
            return formulas.margin5_CrossCur3()
            
        default:
            return 0
        }
    }
    
}

extension Calculator {
    
    fileprivate struct Formulas {
        
        private let _position: Position!
        private let _accountCurrency = UserDefaultsManager().accountCurrency
        
        private var _accountLeverage: Double {
            
            guard let leverageParts = UserDefaultsManager().leverage?.components(separatedBy: ":") else {
                return 0
            }
            
            guard let leverageValue = Int(leverageParts[1]) else {
                return 0
            }
            
            return Double(leverageValue)
            
        }
        
        init(position: Position) {
            _position = position
        }
        
        //Additional Calculations
        func getValueSize() -> Double {
            return _position.value * 100000
        }
        
        func getProfitDifference() -> Double {
            
            switch _position.dealDirection {
            case "Sell":
                return _position.openPrice - _position.takeProfit
            default:
                return _position.takeProfit - _position.openPrice
            }
        }
        
        func getLossDifference() -> Double {
            
            switch _position.dealDirection {
            case "Sell":
                return _position.openPrice - _position.stopLoss
            default:
                return _position.stopLoss - _position.openPrice
            }
            
        }
        
        //Profit formulas
        func profit1_LocalUSD() -> Double {
            return (getValueSize() * getProfitDifference()) / 1
        }
        
        func profit2_USDLocal() -> Double {
            return (getValueSize() * getProfitDifference()) / _position.currentRateXX1XX2
        }
        
        func profit3_CrossCur1() -> Double {
            return (getValueSize() * getProfitDifference()) / _position.currentRateUSDXX2
        }
        
        func profit4_CrossCur2() -> Double {
            return (getValueSize() * getProfitDifference()) / (1 / _position.currentRateXX2USD)
        }
        
        func profit5_CrossCur3() -> Double {
            return (getValueSize() * getProfitDifference()) / _position.currentRateUSDXX2
        }
        
        //Loss formulas
        func loss1_LocalUSD() -> Double {
            return (getValueSize() * getLossDifference()) / 1
        }
        
        func loss2_USDLocal() -> Double {
            return (getValueSize() * getLossDifference()) / _position.currentRateXX1XX2
        }
        
        func loss3_CrossCur1() -> Double {
            return (getValueSize() * getLossDifference()) / _position.currentRateUSDXX2
        }
        
        func loss4_CrossCur2() -> Double {
            return (getValueSize() * getLossDifference()) / (1 / _position.currentRateXX2USD)
        }
        
        func loss5_CrossCur3() -> Double {
            return (getValueSize() * getLossDifference()) / _position.currentRateUSDXX2
        }
        
        //Margin formulas
        func margin1_LocalUSD() -> Double {
            return (_position.currentRateXX1XX2 * getValueSize()) / _accountLeverage
        }
        
        func margin2_USDLocal() -> Double {
            return getValueSize() / _accountLeverage
        }
        
        func margin3_CrossCur1() -> Double {
            return (_position.currentRateXX1USD * getValueSize()) / _accountLeverage
        }
        
        func margin4_CrossCur2() -> Double {
            return (_position.currentRateXX1USD * getValueSize()) / _accountLeverage
        }
        
        func margin5_CrossCur3() -> Double {
            return (_position.currentRateXX1XX2 * getValueSize()) / _accountLeverage
        }
        
    }
    
    struct FormulaOption {
        
        var localUSD = [
            "AUDUSD",
            "EURUSD",
            "GBPUSD",
            "NZDUSD"
        ]
        
        var USDLocal = [
            "USDCAD",
            "USDCHF",
            "USDJPY",
            "USDCNH",
            "USDCZK",
            "USDDKK",
            "USDHKD",
            "USDHUF",
            "USDMXN",
            "USDNOK",
            "USDPLN",
            "USDRUB",
            "USDSGD",
            "USDSEK",
            "USDTHB",
            "USDTRY",
            "USDZAR"
        ]
        
        var crossCur1 = [
            "AUDCAD",
            "AUDCHF",
            "AUDJPY",
            "EURCAD",
            "EURCHF",
            "EURJPY",
            "GBPCAD",
            "GBPCHF",
            "GBPJPY",
            "NZDCAD",
            "NZDCHF",
            "NZDJPY",
            "AUDSGD",
            "EURDKK",
            "EURHKD",
            "EURNOK",
            "EURPLN",
            "EURSEK",
            "EURSGD",
            "EURTRY",
            "EURZAR",
            "GBPDKK",
            "GBPNOK",
            "GBPSEK",
            "GBPSGD",
            "NOKJPY",
            "NOKSEK"
        ]
        
        var crossCur2 = [
            "AUDNZD",
            "EURAUD",
            "EURGBP",
            "EURNZD",
            "GBPAUD",
            "GBPNZD"
        ]
        
        var crossCur3 = [
            "CADCHF",
            "CADJPY",
            "CHFJPY",
            "CHFSGD",
            "SEKJPY",
            "SGDJPY"
            
        ]
        
    }
    
}
