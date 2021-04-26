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
    
    static let regularNumberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .decimal
        
        return formatter
    }()
    
    static let longDecimalsNumberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 6
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .decimal
        
        return formatter
    }()
    
    func string(from value: Double) -> String? {
        self.string(from: NSNumber(value: value))
    }
}

extension DateFormatter {
    static let regularDateAndTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy hh:mm"
        
        return formatter
    }()
}
