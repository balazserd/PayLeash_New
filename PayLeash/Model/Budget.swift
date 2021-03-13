//
//  Budget.swift
//  PayLeash
//
//  Created by Balazs Erdesz on 2021. 02. 23..
//

import Foundation
import Combine

struct Budget {
    var name: String
    var interval: BudgetInterval
    var amount: Double
    var category: TransactionCategory
    var beganAt: Date
}
