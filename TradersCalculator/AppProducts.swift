//
//  AppProducts.swift
//  TradersCalculator
//
//  Created by Yaroslav Zhurbilo on 11.09.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

public struct AppProducts {
  
  public static let BuyProProductID = "com.diglabstudio.TraderCalculator.BuyProVersion"
  
  fileprivate static let productIdentifiers: Set<ProductIdentifier> = [AppProducts.BuyProProductID]

  public static let store = IAPHelper(productIds: AppProducts.productIdentifiers)
}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
  return productIdentifier.components(separatedBy: ".").last
}
