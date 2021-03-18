//
//  CoreData+ExampleData.swift
//  PayLeash
//
//  Created by Balazs Erdesz on 2021. 03. 14..
//

import Foundation
import CoreData
import UIKit
import SwiftDate

@discardableResult func generateUnsavedMockData() -> ([Account], [[BalanceChange]]) {
    //Currencies
    let moc = AppDelegate.sharedInstance.persistentContainer.viewContext
    let currencyHUF = Currency(entity: NSEntityDescription.entity(forEntityName: "Currency", in: moc)!, insertInto: moc)
    currencyHUF.fullName = "Hungarian Forint"
    currencyHUF.shortName = "HUF"
    currencyHUF.symbol = "Ft"
    currencyHUF.id = UUID()
    let currencyEUR = Currency(entity: NSEntityDescription.entity(forEntityName: "Currency", in: moc)!, insertInto: moc)
    currencyEUR.fullName = "Euro"
    currencyEUR.shortName = "EUR"
    currencyEUR.symbol = "€"
    currencyEUR.id = UUID()

    let account1 = Account(entity: NSEntityDescription.entity(forEntityName: "Account", in: moc)!, insertInto: moc)
    account1.bankName = "Budapest Bank"
    account1.currency = currencyHUF
    account1.name = "Student+ Account"
    account1.id = UUID()
    let account2 = Account(entity: NSEntityDescription.entity(forEntityName: "Account", in: moc)!, insertInto: moc)
    account2.bankName = "Budapest Bank"
    account2.currency = currencyEUR
    account2.name = "Forex Extra Account"
    account2.id = UUID()
    let account3 = Account(entity: NSEntityDescription.entity(forEntityName: "Account", in: moc)!, insertInto: moc)
    account3.bankName = "Budapest Bank"
    account3.currency = currencyHUF
    account3.name = "Home savings Account"
    account3.id = UUID()

    let category1 = TransactionCategory(entity: NSEntityDescription.entity(forEntityName: "TransactionCategory", in: moc)!, insertInto: moc)
    category1.icon = "🎓"
    category1.name = "Education"
    category1.id = UUID()
    let category2 = TransactionCategory(entity: NSEntityDescription.entity(forEntityName: "TransactionCategory", in: moc)!, insertInto: moc)
    category2.icon = "💰"
    category2.name = "Income"
    category2.id = UUID()
    let category3 = TransactionCategory(entity: NSEntityDescription.entity(forEntityName: "TransactionCategory", in: moc)!, insertInto: moc)
    category3.icon = "📈"
    category3.name = "Stock earnings"
    category3.id = UUID()
    let category4 = TransactionCategory(entity: NSEntityDescription.entity(forEntityName: "TransactionCategory", in: moc)!, insertInto: moc)
    category4.icon = "🔁"
    category4.name = "Transfer"
    category4.id = UUID()

    let transaction1 = BalanceChange(entity: NSEntityDescription.entity(forEntityName: "BalanceChange", in: moc)!, insertInto: moc)
    transaction1.account = account1
    transaction1.amount = -12479
    transaction1.category = category1
    transaction1.title = "Books for econ class"
    transaction1.time = Date() - 3.days
    transaction1.id = UUID()
    let transaction2 = BalanceChange(entity: NSEntityDescription.entity(forEntityName: "BalanceChange", in: moc)!, insertInto: moc)
    transaction2.account = account1
    transaction2.amount = 255319
    transaction2.category = category2
    transaction2.title = "Monthly salary"
    transaction2.time = Date() - 4.hours
    transaction2.id = UUID()
    let transaction3 = BalanceChange(entity: NSEntityDescription.entity(forEntityName: "BalanceChange", in: moc)!, insertInto: moc)
    transaction3.account = account2
    transaction3.amount = 154.32
    transaction3.category = category3
    transaction3.title = "S&P500 March options excercise"
    transaction3.time = Date() - 7.days + 15.hours
    transaction3.id = UUID()
    let transaction4 = BalanceChange(entity: NSEntityDescription.entity(forEntityName: "BalanceChange", in: moc)!, insertInto: moc)
    transaction4.account = account3
    transaction4.amount = 120000
    transaction4.category = category4
    transaction4.title = "Monthly transfer"
    transaction4.time = Date() - 10.minutes
    transaction4.id = UUID()

    var t1 = Array(repeating: transaction1, count: 7)
    t1.insert(contentsOf: Array(repeating: transaction2, count: 2), at: 0)
    t1.shuffle()

    return (
        [account1, account2, account3],
        [t1, Array(repeating: transaction3, count: 12), Array(repeating: transaction4, count: 4)]
    )
}
