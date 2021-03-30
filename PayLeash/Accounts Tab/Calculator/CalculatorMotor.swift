//
//  CalculatorMotor.swift
//  PayLeash
//
//  Created by Balazs Erdesz on 2021. 03. 29..
//

import Foundation
import Combine

/// A regular calculator's class implementation.
class CalculatorMotor: ObservableObject {
    
    /// The current result of the calculator motor.
    ///
    /// Make sure you have the latest result by calling `evaluate()` before accessing this property.
    ///
    /// Alternatively, query the `calculationsAreDue` property to know whether you should call `evaluate()`.
    @Published private(set) var result: Double = 0.0
    
    /// Communicates whether the motor is capable of performing an evaluation in its current state.
    ///
    /// For example, if there is an even number of elements in the `calculationUnits` array, this property returns false.
    @Published private(set) var canEvaluate: Bool = false
    
    /// The collection of all calculations units that await evaluation.
    ///
    /// This array should contain `Double` elements on even and `OperationType` elements on odd indexes.
    /// Not respecting this rule results in undefined behavior and might cause a runtime exception.
    @Published private(set) var calculationUnits: [CalculationUnit] = []
    
    /// Tells whether the next `CalculationUnit` added to the `calculationUnits` array should be an `OperationType`.
    var acceptsOperator: Bool {
        guard let lastElement = calculationUnits.last else {
            return false //if there are no elements, we need a Double
        }
        
        return lastElement as? Double != nil
    }
    
    /// Tells whether the next `CalculationUnit` added to the `calculationUnits` array should be a `Double`.
    var acceptsValue: Bool { !acceptsOperator }
    
    /// Tells whether calculations should be done before accessing the `result` property.
    var calculationsAreDue: Bool {
        calculationUnits.count > 1 || calculationUnits[0] as! Double != result
    }
    
    private var higherOrderOperatorsMayExist: Bool = true
    private var currentlyTypedNumber: String = "0"
    
    /// The full unevaluated expression, that a normal calculator would show.
    @Published var fullExpressionString: String = ""
    
    /// Attempts to attach an operation at the end of the `calculationUnits`array.
    ///
    /// - Parameter operation: The operation to attach.
    ///
    /// - Returns: A `Bool` value, communicating whether attachment was successful.
    @discardableResult func appendOperation(of operation: OperationType) -> Bool {
        //Having one number is a special case as that means the user has just pressed the equal sign.
        if calculationUnits.count == 1 {
            calculationUnits.append(operation)
            fullExpressionString += " \(operation.character) "
            
            return true
        }
        
        if acceptsValue {
            calculationUnits.append(Double(currentlyTypedNumber) ?? Double(currentlyTypedNumber.dropLast())!) //Maybe a decimalPoint was added, drop that.
            currentlyTypedNumber = "0"
            
            calculationUnits.append(operation)
            
            fullExpressionString += " \(operation.character) "
            
            return true
        }
        
        return false
    }
    
    func type(digitOrDecimalSeparator: String) {
        let decimalSeparator = Locale.current.decimalSeparator ?? "."
        
        if currentlyTypedNumber.contains(decimalSeparator) && digitOrDecimalSeparator == decimalSeparator {
            return // Do not allow multiple decimalSeparators
        }
        
        currentlyTypedNumber += digitOrDecimalSeparator
        fullExpressionString += digitOrDecimalSeparator
    }
    
    func typeEqualSign() {
        if acceptsValue {
            calculationUnits.append(Double(currentlyTypedNumber) ?? Double(currentlyTypedNumber.dropLast())!)
            currentlyTypedNumber = "0"
            
            evaluate()
        }
    }
    
    /// Evaluates all calculation units.
    ///
    /// Not respecting the build rules of the `calculationUnits` array is undefined behavior and might cause a runtime exception.
    func evaluate() {
        if calculationUnits.count % 2 != 1 {
            //If the calculationUnits array contains and even number of elements, evaluation cannot be done.
            return
        }
        
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
        let resultAsString = NumberFormatter.longDecimalsNumberFormatter.string(from: result)!
        
        fullExpressionString = resultAsString
        currentlyTypedNumber = resultAsString
        
        higherOrderOperatorsMayExist = true
    }
    
    /// Resets the calculator motor to the initial state.
    ///
    /// This essentially means that the `result` property is set to 0 and the `calculationUnits` array is cleared.
    func clear() {
        result = 0.0
        calculationUnits = []
    }
    
    private func evaluateOperation(at index: Int) {
        let operationType = calculationUnits[index] as! OperationType
        let lhs = calculationUnits[index - 1] as! Double
        let rhs = calculationUnits[index + 1] as! Double
        
        calculationUnits.removeSubrange(index-1...index+1)
        calculationUnits.insert(operationType.operation(lhs, rhs), at: index - 1)
    }
    
    private var cancellableSet = Set<AnyCancellable>()
}
