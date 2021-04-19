//
//  CalculationUnits.swift
//  PayLeash
//
//  Created by Balazs Erdesz on 2021. 03. 29..
//

import Foundation

protocol CalculationUnit { }

extension Double: CalculationUnit { }

enum OperationType: CalculationUnit {
    case substract
    case add
    case multiply
    case divide
    
    var order: Int {
        switch self {
            case .add, .substract: return 2
            case .multiply, .divide: return 1
        }
    }
    
    var operation: (Double, Double) -> Double {
        switch self {
            case .add: return { $0 + $1 }
            case .substract: return { $0 - $1 }
            case .multiply: return { $0 * $1 }
            case .divide: return { $0 / $1 }
        }
    }
    
    var iconName: String {
        switch self {
            case .add: return "plus"
            case .substract: return "minus"
            case .multiply: return "multiply"
            case .divide: return "divide"
        }
    }
    
    func character(withSpacesAround: Bool = false) -> String {
        switch self {
            case .add: return withSpacesAround ? " + " : "+"
            case .substract: return withSpacesAround ? " − " : "−"
            case .multiply: return withSpacesAround ? " × " : "×"
            case .divide: return withSpacesAround ? " ÷ " : "÷"
        }
    }
    
    
}
