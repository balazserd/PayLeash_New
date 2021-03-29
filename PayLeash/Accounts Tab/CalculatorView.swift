//
//  CalculatorView.swift
//  PayLeash
//
//  Created by Balazs Erdesz on 2021. 03. 28..
//

import SwiftUI

struct CalculatorView: View {
    @Binding var currentResult: Double
    
    @State private var expressionString: String = ""
    
    private let mainPadding: CGFloat = 9
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                Text(expressionString)
                    .systemFont(size: 16)
                    .foregroundColor(.secondary)
                    .frame(height: 40)
                
                VStack {
                    HStack(spacing: 13) {
                        HStack(spacing: 10) {
                            numberPad(of: "1")
                            numberPad(of: "2")
                            numberPad(of: "3")
                        }
                        .frame(width: (proxy.size.width - 2 * mainPadding) * 0.65)
                        
                        HStack(spacing: 10) {
                            operatorPad(iconName: "plus")
                            operatorPad(iconName: "plus.slash.minus")
                        }
                    }
                    
                    HStack(spacing: 13) {
                        HStack(spacing: 10) {
                            numberPad(of: "4")
                            numberPad(of: "5")
                            numberPad(of: "6")
                        }
                        .frame(width: (proxy.size.width - 2 * mainPadding) * 0.65)
                        
                        HStack(spacing: 10) {
                            operatorPad(iconName: "minus")
                            operatorPad(iconName: "divide")
                        }
                    }
                    
                    HStack(spacing: 13) {
                        HStack(spacing: 10) {
                            numberPad(of: "7")
                            numberPad(of: "8")
                            numberPad(of: "9")
                        }
                        .frame(width: (proxy.size.width - 2 * mainPadding) * 0.65)
                        
                        HStack(spacing: 10) {
                            operatorPad(iconName: "multiply")
                            operatorPad(iconName: "equal")
                        }
                    }
                    
                    HStack {
                        doubleNumberPad(of: "0")
                        numberPad(of: ".")
                    }
                }
                .padding(mainPadding)
                .aspectRatio(2, contentMode: .fit)
            }
        }
    }
    
    private func numberPad(of number: String) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(Colors.Green.typed(.inputTextGreen))
            
            Text("\(number)")
                .systemFont(size: 16, weight: .bold)
                .foregroundColor(.white)
        }
    }
    
    private func doubleNumberPad(of number: String) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(Colors.Green.typed(.inputTextGreen))
            
            Text("\(number)")
                .systemFont(size: 16, weight: .bold)
                .foregroundColor(.white)
        }
    }
    
    private func operatorPad(iconName: String) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .strokeBorder(Colors.Green.typed(.prominentGreen), lineWidth: 2)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .foregroundColor(Colors.Green.typed(.backgroundGreen))
                )
            
            Text("\(Image(systemName: iconName))")
                .systemFont(size: 14, weight: .bold)
                .foregroundColor(Colors.Green.typed(.prominentGreen))
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
            
            CalculatorView(currentResult: $value)
            
            Spacer()
        }
    }
}
