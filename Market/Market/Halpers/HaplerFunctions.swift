//
//  HaplerFunctions.swift
//  Market
//
//  Created by KurbanAli on 31/12/20.
//

import Foundation

func convertToCurrency (_ number: Double) -> String {
    let currencyFormatter = NumberFormatter()
    
    currencyFormatter.usesGroupingSeparator = true
    currencyFormatter.numberStyle = .currency
    currencyFormatter.locale = Locale.current
    
    let priceString = currencyFormatter.string(from: NSNumber(value: number))!
    
    return priceString
}
