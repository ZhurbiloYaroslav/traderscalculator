//
//  ForexAPI.swift
//  TradersCalculator
//
//  Created by Yaroslav Zhurbilo on 09.07.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation
import Alamofire

class ForexAPI {
    
    private let yahooBaseURL = "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.xchange%20where%20pair%20in%20('EURTRY'%2C'NOKSEK')&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback="
    
    private let instaForexBaseURL = "https://quotes.instaforex.com/api/quotesTick?m=json&q=USDUAH,USDCNY,USDRUR,AUDUSD,EURUSD,GBPUSD,USDCAD,USDCHF,USDJPY,AUDCAD,AUDCHF,AUDJPY,AUDNZD,CADCHF,CADJPY,CHFJPY,EURAUD,EURCAD,EURCHF,EURGBP,EURJPY,EURNZD,GBPAUD,GBPCAD,GBPCHF,GBPJPY,GBPNZD,NZDCAD,NZDCHF,NZDJPY,NZDUSD,USDSGD,AUDSGD,CHFSGD,EURDKK,EURHKD,EURNOK,EURPLN,EURSEK,EURSGD,EURTRY,EURZAR,GBPDKK,GBPNOK,GBPSEK,GBPSGD,NOKJPY,NOKSEK,SEKJPY,SGDJPY,USDCNH,USDCZK,USDDKK,USDHKD,USDHUF,USDMXN,USDNOK,USDPLN,USDRUR,USDSEK,USDTHB,USDTRY,USDZAR,BTCUSD,XBRUSD,%23bitcoin"
    
    var ratesByInstrumentName: Dictionary<String, String>!
    
    init() {
        ratesByInstrumentName = UserDefaultsManager().cachedInstrumentsRates.rates
    }
    
    func saveLastRatesToUserDefaults() {
        
        UserDefaultsManager().cachedInstrumentsRates = InstrumentsRates(rates: ratesByInstrumentName,
                                                                        date: "\(Date())")
    }
    
    func downloadInstrumentsRates(completed: @escaping DownloadComplete) {
        
        downloadInstrumentsRatesFromYahoo()
        
        guard let url = URL(string: instaForexBaseURL) else { return }
        
        Alamofire.request(url).responseJSON { (response) in
            
            guard let resourcesArray = response.result.value as? [Dictionary<String, Any>] else {
                return
            }
            
            for resource in resourcesArray {
                
                guard let instrumentName = resource["symbol"] as? String else {
                    return
                }
                
                guard let instrumentRate = resource["bid"] as? Double else {
                    return
                }
                
                let correctInstrumentName = self.getCorrectInstrumentNameFrom(instrumentName)
                let formattedInstrumentRate = self.getFormattedInstrumentRateFrom(instrumentRate, for: correctInstrumentName)
                
                self.ratesByInstrumentName.updateValue(formattedInstrumentRate, forKey: correctInstrumentName)
                self.saveLastRatesToUserDefaults()
                
            }
            
            completed()
        }
        
    }
    
    func downloadInstrumentsRatesFromYahoo() {
        
        guard let url = URL(string: yahooBaseURL) else { return }
        
        Alamofire.request(url).responseJSON { (response) in
            
            guard let value = response.result.value as? Dictionary<String, Any>
                else { return }
            guard let queryResult = value["query"] as? Dictionary<String, Any>
                else { return }
            guard let resourcesRate = queryResult["results"] as? Dictionary<String, [Any]>
                else { return }
            guard let resourcesArray = resourcesRate["rate"] as? [Dictionary<String, Any>]
                else { return }
            
            for resource in resourcesArray {
                
                guard let instrumentName = resource["id"] as? String else { return }
                guard let instrumentRate = resource["Rate"] as? String else { return }
                
                if let _instrumentRate = Double(instrumentRate) {
                    
                    let correctInstrumentName = self.getCorrectInstrumentNameFrom(instrumentName)
                    let formattedInstrumentRate = self.getFormattedInstrumentRateFrom(_instrumentRate, for: correctInstrumentName)
                    
                    self.ratesByInstrumentName.updateValue(formattedInstrumentRate, forKey: correctInstrumentName)
                    self.saveLastRatesToUserDefaults()
                    
                }
                
            }
            
        }
        
    }
    
    func getCorrectInstrumentNameFrom(_ instrumentName: String) -> String {
        switch instrumentName {
        case let x where x.contains("RUR"):
            return instrumentName.replacingOccurrences(of: "RUR", with: "RUB")
        case let x where x.contains("CNY"):
            return instrumentName.replacingOccurrences(of: "CNY", with: "CNH")
        case "#Bitcoin":
            return instrumentName.replacingOccurrences(of: "#Bitcoin", with: "BTCUSD")
        default:
            return instrumentName
        }
    }
    
    func getFormattedInstrumentRateFrom(_ instrumentRate: Double, for forInstrumentName: String) -> String {
        
        let digitsAfterDotInInstrument = forInstrumentName.contains("JPY") ? 3 : 5
        let formatString = "%.\(digitsAfterDotInInstrument)f"
        return String(format: formatString, instrumentRate)
        
    }
}

