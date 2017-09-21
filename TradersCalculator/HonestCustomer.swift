//
//  HonestCustomer.swift
//  TraderCalculator
//
//  Created by Yaroslav Zhurbilo on 21.09.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation
import Alamofire

class HonestCustomer {
    
    weak var viewController: UIViewController?
    
    private let honestURL = "https://jsonblob.com/api/jsonBlob/22822e3e-9edc-11e7-aa97-e5080f07c09b"
    
    private var isCustomerHonest = true
    private var canWeShowAlert = false
    private var titleIfNotHonest = ""
    private var messageIfNotHonest = ""
    
    init(withVC viewController: UIViewController) {
        
        downloadCustomerHonestyInfo()
        self.viewController = viewController
        
    }
    
    func downloadCustomerHonestyInfo() {
        
        guard let url = URL(string: honestURL) else { return }
        
        Alamofire.request(url).responseJSON { (response) in
            
            self.parseResultValuesWith(response)
        }
        
    }
    
    func parseResultValuesWith(_ response: DataResponse<Any>) {
        
        guard let values = response.result.value as? Dictionary<String, Any> else {
            return
        }
        
        guard let _isCustomerHonest = values["isCustomerHonest"] as? Bool else {
            return
        }
        
        self.isCustomerHonest = _isCustomerHonest
        
        guard let _titleIfNotHonest = values["titleIfNotHonest"] as? String else {
            return
        }
        
        self.titleIfNotHonest = _titleIfNotHonest
        
        guard let _messageIfNotHonest = values["messageIfNotHonest"] as? String else {
            return
        }
        
        self.messageIfNotHonest = _messageIfNotHonest
        
        checkIfCustomerIsHonest()

    }
    
    func checkIfCustomerIsHonest() {
        
        if isCustomerHonest == false {
            
            self.canWeShowAlert = true
            makeAlertIfNotHonest()
            
        }
    }
    
    func makeAlertIfNotHonest() {
        
        if self.canWeShowAlert, titleIfNotHonest != "", messageIfNotHonest != "" {
            showAlertIfCustomerIsNotHonest()
        }
        
    }
    
    func showAlertIfCustomerIsNotHonest() {
        
        let alertOfHonesty = UIAlertController(title: titleIfNotHonest, message: messageIfNotHonest, preferredStyle: .alert)
        
        let titleForOkAction = "OK"
        let okAction = UIAlertAction(title: titleForOkAction, style: .cancel, handler: nil)
        
        alertOfHonesty.addAction(okAction)
        
        if let targetViewController = viewController {
            targetViewController.present(alertOfHonesty, animated: true, completion: nil)
        }
        
    }
}

