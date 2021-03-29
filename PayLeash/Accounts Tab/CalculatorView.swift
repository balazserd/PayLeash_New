//
//  CalculatorView.swift
//  PayLeash
//
//  Created by Balazs Erdesz on 2021. 03. 28..
//

import SwiftUI

struct CalculatorView: View {
    @Binding var currentResult: Double
    var doneAction: () -> Void
    
    init(currentResult: Binding<Double>, doneAction: @escaping () -> Void) {
        self._currentResult = currentResult
        self.doneAction = doneAction
    }
    
    @State private var expressionString: String = ""
    private var expressionLeftHandSide: Double? = nil
    private var expressionRightHandSide: Double? = nil
    private var calculationUnits: [CalculationUnit] = []
    
    private let mainPadding: CGFloat = 9
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                Text(expressionString)
                    .systemFont(size: 16)
                    .foregroundColor(.secondary)
                    .frame(height: 40)
                
                VStack {
                    calculatorRow(proxy: proxy,
                                  numberPadContent: {
                                    numberButton(of: 1)
                                    numberButton(of: 2)
                                    numberButton(of: 3)
                                  },
                                  operatorPadContent: {
                                    oppositeButton
                                    destructingOperatorPad(letter: "C")
                                  })
                    
                    calculatorRow(proxy: proxy,
                                  numberPadContent: {
                                    numberButton(of: 4)
                                    numberButton(of: 5)
                                    numberButton(of: 6)
                                  },
                                  operatorPadContent: {
                                    operatorButton(of: .substract)
                                    operatorButton(of: .divide)
                                  })
                    
                    calculatorRow(proxy: proxy,
                                  numberPadContent: {
                                    numberButton(of: 7)
                                    numberButton(of: 8)
                                    numberButton(of: 9)
                                  },
                                  operatorPadContent: {
                                    operatorButton(of: .multiply)
                                    operatorButton(of: .add)
                                  })
                    
                    calculatorRow(proxy: proxy,
                                  numberPadContent: {
                                    importantOperatorButton(name: "=",
                                                            operation: {
                                                                
                                                            })
                                    numberButton(of: 0)
                                    decimalButton
                                  },
                                  operatorPadContent: {
                                    importantOperatorButton(name: "Done") {
                                        doneAction()
                                    }
                                  })
                }
                .padding(mainPadding)
                .aspectRatio(2, contentMode: .fit)
            }
            .shadow(color: .gray.opacity(0.4), radius: 5, x: 0, y: 2)
        }
    }
    
    private func calculatorRow<NPC: View, OPC: View>(proxy: GeometryProxy,
                                                     @ViewBuilder numberPadContent: () -> NPC,
                                                     @ViewBuilder operatorPadContent: () -> OPC) -> some View {
        HStack(spacing: 13) {
            HStack(spacing: 10) {
                numberPadContent()
            }
            .frame(width: (proxy.size.width - 2 * mainPadding) * 0.65)
            
            HStack(spacing: 10) {
                operatorPadContent()
            }
        }
    }
    
    private func numberButton(of number: Int) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(Colors.Green.typed(.inputTextGreen))
            
            Text("\(number)")
                .systemFont(size: 16, weight: .bold)
                .foregroundColor(.white)
        }
        .onTapGesture {
            expressionString += String(number)
        }
    }
    
    private var decimalButton: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(Colors.Green.typed(.inputTextGreen))
            
            Text(".")
                .systemFont(size: 16, weight: .bold)
                .foregroundColor(.white)
        }
        .onTapGesture {
            expressionString += "."
        }
    }
    
    private func operatorButton(of operation: OperationType) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .strokeBorder(Colors.Green.typed(.prominentGreen), lineWidth: 2)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .foregroundColor(Colors.Green.typed(.backgroundGreen))
                )
            
            Text("\(Image(systemName: operation.iconName))")
                .systemFont(size: 14, weight: .bold)
                .foregroundColor(Colors.Green.typed(.prominentGreen))
        }
        .onTapGesture {
            expressionString += " \(operation.character) "
        }
    }
    
    private var oppositeButton: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .strokeBorder(Colors.Green.typed(.prominentGreen), lineWidth: 2)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .foregroundColor(Colors.Green.typed(.backgroundGreen))
                )
            
            Text("\(Image(systemName: "plus.slash.minus"))")
                .systemFont(size: 14, weight: .bold)
                .foregroundColor(Colors.Green.typed(.prominentGreen))
        }
        .onTapGesture {
            expressionString += " "
        }
    }
    
    private func destructingOperatorPad(letter: String) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(Colors.Red.typed(.darkRed))
            
            Text("\(letter)")
                .systemFont(size: 16, weight: .bold)
                .foregroundColor(.white)
        }
    }
    
    private func importantOperatorButton(name: String, operation: @escaping () -> Void) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(Colors.Green.typed(.prominentGreen))
            
            Text("\(name)")
                .systemFont(size: 16, weight: .bold)
                .foregroundColor(.white)
        }
        .onTapGesture {
            operation()
        }
    }
}

struct CalculatorView_Previews: PreviewProvider {
    @State private static var value: Double = 0.0
    
    static var previews: some View {
        VStack {
            Spacer()
            
            Text(NumberFormatter.regularNumberFormatter.string(from: value)!)
            
            Spacer()
            
            CalculatorView(currentResult: $value,
                           doneAction: { })
            
            Spacer()
        }
    }
}

//MARK:- Calculation Units
struct CalculationExpression {
    var result: Double
    var calculationUnits: [CalculationUnit] = []
    
    mutating func evaluate() {
        while calculationUnits.count != 1 {
            let firstHighestOrderOperatorLocation = calculationUnits.firstIndex(where: {
                guard let operationType = $0 as? OperationType else { return false }
                
                return operationType.order == 1
            })
            
            evaluateOperation(at: firstHighestOrderOperatorLocation ?? 1)
            
            //begin again
            evaluate()
        }
    }
    
    private mutating func evaluateOperation(at index: Int) {
        let operationType = calculationUnits[index] as! OperationType
        let lhs = calculationUnits[index - 1] as! Double
        let rhs = calculationUnits[index + 1] as! Double
        
        calculationUnits.removeSubrange(index-1...index+1)
        calculationUnits.insert(operationType.operation(lhs, rhs), at: index - 1)
    }
}
protocol CalculationUnit { }

extension Double: CalculationUnit { }

fileprivate enum OperationType: CalculationUnit {
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
    
    var character: String {
        switch self {
            case .add: return "+"
            case .substract: return "-"
            case .multiply: return "􀅾"
            case .divide: return "􀅿"
        }
    }
}
