//
//  TransactionBudgetLine.swift
//  PayLeash
//
//  Created by Balazs Erdesz on 2021. 02. 23..
//

import SwiftUI
import Combine

struct TransactionBudgetLine: View {
    @ObservedObject var model: ViewModel
    
    var body: some View {
        HStack(spacing: 3) {
            Image(systemName: getIconName(for: model.budget.interval))
                .frame(height: 16)
                .foregroundColor(Colors.Green.typed(.mediumGreen).opacity(0.6))
            
            GeometryReader { proxy in
                buildBarView(in: proxy)
            }
        }
        .frame(height: 20)
    }
    
    private func buildBarView(in proxy: GeometryProxy) -> some View {
        let beforeBarWidth = calculateBarWidth(fullWidth: proxy.size.width - 2,
                                               budgetTotal: model.budget.amount,
                                               spent: model.spentBefore + model.spentNow)
        let afterBarWidth = calculateBarWidth(fullWidth: proxy.size.width - 2,
                                              budgetTotal: model.budget.amount,
                                              spent: model.spentBefore)
        
        let shouldAlignLabelToBeginning = (model.spentBefore + model.spentNow) / model.budget.amount > 0.5
        
        return ZStack(alignment: Alignment(horizontal: .leading, vertical: .center)) {
            RoundedRectangle(cornerRadius: 2)
                .fill(Colors.Gray.typed(.lightGray))
            
            RoundedRectangle(cornerRadius: 2)
                .fill(Colors.Green.typed(.mediumGreen).opacity(0.6))
                .padding(1)
                .frame(width: beforeBarWidth)
            
            RoundedRectangle(cornerRadius: 2)
                .fill(Colors.Green.typed(.mediumGreen))
                .padding(1)
                .frame(width: afterBarWidth)
            
            Text(model.budget.category.name)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(shouldAlignLabelToBeginning ? Color.white : Colors.Green.typed(.mediumGreen))
                .offset(x: shouldAlignLabelToBeginning ? 0 : beforeBarWidth, y: 0)
                .padding(.leading, 5)
                .frame(maxWidth: proxy.size.width / 3, alignment: .leading)
            
            Text(getBudgetPercentText(spent: model.spentBefore + model.spentNow,
                                      budgetTotal: model.budget.amount))
                .foregroundColor(Colors.Green.typed(.mediumGreen))
                .font(.system(size: 12))
                .bold()
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 3)
        }
        .frame(alignment: .leading)
    }
    
    private func getIconName(for interval: BudgetInterval) -> String {
        switch interval {
            case .weekly: return "w.square"
            case .monthly: return "m.square"
            case .quarterly: return "q.square"
            case .yearly: return "y.square"
        }
    }
    
    private func calculateBarWidth(fullWidth: CGFloat, budgetTotal: Double, spent: Double) -> CGFloat {
        return fullWidth * CGFloat(spent / budgetTotal)
    }
    
    private let percentageFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        
        return formatter
    }()
    
    private func getBudgetPercentText(spent: Double, budgetTotal: Double) -> String {
        "\(percentageFormatter.string(from: NSNumber(value: spent / budgetTotal * 100))!)%"
    }
}

extension TransactionBudgetLine {
    class ViewModel: ObservableObject {
        @Published var budget: Budget = Budget(name: "Food & Drinks monthly budget",
                                               interval: .monthly,
                                               amount: 250.0,
                                               category: TransactionCategory(name: "Food & Drinks",
                                                                             iconName: "star.fill"),
                                               beganAt: Date().addingTimeInterval(-5 * 24 * 60 * 60))
        @Published var spentBefore: Double = 158.45
        @Published var spentNow: Double = 8.87
    }
}

struct TransactionBudgetLine_Previews: PreviewProvider {
    static var previews: some View {
        TransactionBudgetLine(model: TransactionBudgetLine.ViewModel())
            .padding()
    }
}
