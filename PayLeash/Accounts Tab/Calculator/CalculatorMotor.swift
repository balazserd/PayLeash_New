//
//  CalculatorMotor.swift
//  PayLeash
//
//  Created by Balazs Erdesz on 2021. 03. 29..
//

import Foundation
import Combine

class CalculatorMotor: ObservableObject {
    
    /// The current result of the calculator motor.
    ///
    /// Make sure you have the latest result by calling `evaluate()` before accessing this property.
    ///
    /// Alternatively, query the `calculationsAreDue` property to know whether you should call `evaluate()`.
    @Published var result: Double = 0.0
    
    /// The collection of all calculations units that await evaluation.
    ///
    /// This array should contain `Double` elements on even and `OperationType` elements on odd indexes.
    /// Not respecting this rule results in undefined behavior and might cause a runtime exception.
    var calculationUnits: [CalculationUnit] = []
    
    /// Tells whether calculations should be done before accessing the `result` property.
    var calculationsAreDue: Bool { calculationUnits.count > 1 || calculationUnits[0] as! Double != result }
    
    private var higherOrderOperatorsMayExist: Bool = true
    
    /// Evaluates all calculation units.
    ///
    /// Not respecting the build rules of the `calculationUnits` array is undefined behavior and might cause a runtime exception.
    func evaluate() {
        while calculationUnits.count != 1 {
            var firstHighestOrderOperatorLocation: Int? = nil
            
            if higherOrderOperatorsMayExist {
                firstHighestOrderOperatorLocation = calculationUnits.firstIndex(where: {
                    guard let operationType = $0 as? OperationType else { return false }
                    
                    return operationType.order == 1 //try to find a higher order operation (e.g. division / multiplication)
                })
            }
            
            if firstHighestOrderOperatorLocation == nil {
                higherOrderOperatorsMayExist = false
            }
            
            evaluateOperation(at: firstHighestOrderOperatorLocation ?? 1) //If no higher order operator was found, simply start with the first.
            
            //begin again
            evaluate()
        }
        
        result = calculationUnits[0] as! Double
    }
    
    private func evaluateOperation(at index: Int) {
        let operationType = calculationUnits[index] as! OperationType
        let lhs = calculationUnits[index - 1] as! Double
        let rhs = calculationUnits[index + 1] as! Double
        
        calculationUnits.removeSubrange(index-1...index+1)
        calculationUnits.insert(operationType.operation(lhs, rhs), at: index - 1)
    }
}
