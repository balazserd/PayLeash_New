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
    
    @StateObject private var motor = CalculatorMotor()
    
    @State private var viewHeight: CGFloat = 0.0
    
    var body: some View {
        VStack(spacing: 0) {
            Text(motor.fullExpressionString)
                .systemFont(size: 16)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 25)
                .padding(.bottom, 8)
            
            GeometryReader { proxy in
                VStack {
                    calculatorRow(proxy: proxy,
                                  numberPadContent: {
                                    numberButton(of: 1)
                                    numberButton(of: 2)
                                    numberButton(of: 3)
                                  },
                                  operatorPadContent: {
                                    oppositeButton
                                    destructingOperatorButton(letter: "C")
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
                                                            operation: { motor.typeEqualSign() })
                                    numberButton(of: 0)
                                    decimalButton
                                  },
                                  operatorPadContent: {
                                    importantOperatorButton(name: "Done") {
                                        motor.typeEqualSign()
                                        doneAction()
                                    }
                                  })
                }
                .anchorPreference(key: NewTransactionView.CalculatorHeightPreferenceKey.self,
                                  value: .bounds,
                                  transform: { proxy[$0].height })
            }
            .onPreferenceChange(NewTransactionView.CalculatorHeightPreferenceKey.self, perform: { value in
                self.viewHeight = value
            })
            .frame(height: viewHeight)
        }
        .onChange(of: motor.result, perform: { value in
            currentResult = value
        })
        .onAppear(perform: {
            if !currentResult.isEqual(to: 0.0) {
                motor.didOpenWithPreviousFinalResult(of: currentResult)
            }
        })
    }
    
    private func calculatorRow<NPC: View, OPC: View>(proxy: GeometryProxy,
                                                     @ViewBuilder numberPadContent: () -> NPC,
                                                     @ViewBuilder operatorPadContent: () -> OPC) -> some View {
        HStack(spacing: 13) {
            HStack(spacing: 10) {
                numberPadContent()
            }
            .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 2)
            .frame(width: proxy.size.width * 0.62)
            
            HStack(spacing: 10) {
                operatorPadContent()
            }
            .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 2)
        }
        .frame(height: 40)
    }
    
    private func numberButton(of number: Int) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(Colors.Green.typed(.inputTextGreen))
            
            Text("\(number)")
                .systemFont(size: 17, weight: .bold)
                .foregroundColor(.white)
        }
        .onTapGesture {
            motor.type(digitOrDecimalSeparator: String(number))
        }
    }
    
    private var decimalButton: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(Colors.Green.typed(.inputTextGreen))
            
            Text(".")
                .systemFont(size: 17, weight: .bold)
                .foregroundColor(.white)
        }
        .onTapGesture {
            motor.type(digitOrDecimalSeparator: Locale.current.decimalSeparator ?? ".")
        }
    }
    
    private func operatorButton(of operation: OperationType) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(Colors.Green.typed(.extraLightGreen))
            
            Text("\(Image(systemName: operation.iconName))")
                .systemFont(size: 17, weight: .bold)
                .foregroundColor(Colors.Green.typed(.prominentGreen))
        }
        .onTapGesture {
            motor.appendOperation(of: operation)
        }
    }
    
    private var oppositeButton: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(Colors.Green.typed(.extraLightGreen))
            
            Text("\(Image(systemName: "plus.slash.minus"))")
                .systemFont(size: 17, weight: .bold)
                .foregroundColor(Colors.Green.typed(.prominentGreen))
        }
        .onTapGesture {
            motor.typeOpposite()
        }
    }
    
    private func destructingOperatorButton(letter: String) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(Colors.Red.typed(.darkRed))
            
            Text("\(letter)")
                .systemFont(size: 16, weight: .bold)
                .foregroundColor(.white)
        }
        .onTapGesture {
            motor.clear()
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
        .padding()
    }
}
