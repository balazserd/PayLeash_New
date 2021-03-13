//
//  Formatters.swift
//  PayLeash
//
//  Created by Balazs Erdesz on 2021. 02. 24..
//

import Foundation

extension NumberFormatter {
    private static let regularCurrencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        
        return formatter
    }()
    
    static func currencyFormatter(for currencyCode: String) -> NumberFormatter {
        let formatter = Self.regularCurrencyFormatter
        formatter.currencyCode = currencyCode
        
        return formatter
    }
}
