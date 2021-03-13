//
//  TransactionView.swift
//  PayLeash
//
//  Created by Balazs Erdesz on 2021. 02. 23..
//

import SwiftUI
import Combine
import SwiftDate

struct TransactionView: View {
    @ObservedObject var model: ViewModel
    @State private var selected: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(model.categoryName)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                Spacer()
                
                if !selected {
                    Text(model.time.toRelativeShortString())
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.secondary)
                        .transition(.asymmetric(insertion: AnyTransition.opacity.animation(Animation.easeOut.delay(0.2)),
                                                removal: .identity))
                }
                
                Image(systemName: "chevron.up")
                    .rotationEffect(selected ? .degrees(-180) : .zero)
            }
            
            Divider()
                .frame(height: 6)
                .padding(.bottom, 4)
            
            HStack(alignment: .firstTextBaseline) {
                Text(model.transactionName)
                    .font(.system(size: 17, weight: .semibold))
                    .frame(maxWidth: 200, alignment: .leading)
                    .lineLimit(2)
                
                Spacer()
                
                if selected {
                    Text(model.time.toFullDateTimeString())
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                        .transition(.asymmetric(insertion: AnyTransition.opacity.animation(Animation.easeOut.delay(0.2)),
                                                removal: .identity))
                }
            }
            .frame(height: selected ? nil : 40, alignment: .top)
            .anchorPreference(key: AmountLocationPreferenceKey.self, value: .bottomTrailing, transform: {
                [AmountLocationPreferenceKey.Data(isSelected: false, anchorPoint: $0)]
            })
            
            if selected {
                VStack(spacing: 3) {
                    TransactionBudgetLine(model: TransactionBudgetLine.ViewModel())
                    
                    HStack(alignment: .firstTextBaseline, spacing: 0) {
                        Text("Paid: ")
                            .font(.system(size: 12))
                            .anchorPreference(key: AmountLocationPreferenceKey.self, value: .bottomTrailing, transform: {
                                [AmountLocationPreferenceKey.Data(isSelected: true, anchorPoint: $0)]
                            })
                        
                        Spacer()
                        
                        Text("New balance: ")
                            .font(.system(size: 12))
                        
                        Text("\(NumberFormatter.currencyFormatter(for: "USD").string(for: 12455.35)!)")
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .padding(.top, 6)
                }
                .transition(AnyTransition.height.animation(.linear(duration: 0.2)))
                .padding(.top, 8)
            }
        }
        .overlayPreferenceValue(AmountLocationPreferenceKey.self) { preferenceValue in
            GeometryReader { proxy in
                drawAmountLabel(in: proxy, preferenceValue: preferenceValue)
            }
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(selected ? Colors.Green.typed(.extraLightGreen) : .white)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Colors.Green.typed(.mediumGreen),
                                lineWidth: selected ? 1.5 : 0))
                .shadow(x: 0, y: 2, blur: 10, spread: -4)
        )
        .onTapGesture {
            withAnimation(.linear(duration: 0.2)) {
                selected.toggle()
            }
        }
    }
    
    private func drawAmountLabel(in proxy: GeometryProxy, preferenceValue: AmountLocationPreferenceKey.Value) -> some View {
        let preference = preferenceValue
            .first { $0.isSelected == self.selected }!
            .anchorPoint
        let anchoringPoint = proxy[preference]
        
        return ZStack {
            Text("\(NumberFormatter.currencyFormatter(for: "USD").string(for: model.transactionAmount)!)")
                .font(.system(size: selected ? 15 : 17, weight: .bold))
                .foregroundColor(model.transactionAmount < 0
                                    ? Colors.Red.typed(.regularRed)
                                    : Colors.Green.typed(.mediumGreen))
                .alignmentGuide(.leading, computeValue: { d in d[self.selected ? .leading : .trailing] - anchoringPoint.x })
                .alignmentGuide(.top, computeValue: { d in d[.bottom] - anchoringPoint.y })
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

extension TransactionView {
    struct AmountLocationPreferenceKey : PreferenceKey {
        typealias Value = [Data]
    
        static var defaultValue: [Data] = []
        
        static func reduce(value: inout [Data], nextValue: () -> [Data]) {
            value.append(contentsOf: nextValue())
        }
        
        struct Data {
            var isSelected: Bool
            var anchorPoint: Anchor<CGPoint>
        }
    }
}

extension TransactionView {
    class ViewModel: ObservableObject {
        @Published var categoryName: String = "Food & Drinks"
        @Published var time: Date = Date() - 6.days
        @Published var transactionName: String = "Starbucks coffee"
        @Published var transactionAmount: Double = -9.97
    }
}

struct TransactionView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionView(model: TransactionView.ViewModel())
            .frame(maxHeight: 300)
            .padding()
    }
}
