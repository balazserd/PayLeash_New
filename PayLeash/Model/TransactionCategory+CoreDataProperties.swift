//
//  TransactionCategory+CoreDataProperties.swift
//  PayLeash
//
//  Created by Balazs Erdesz on 2021. 03. 14..
//
//

import Foundation
import CoreData


extension TransactionCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TransactionCategory> {
        return NSFetchRequest<TransactionCategory>(entityName: "TransactionCategory")
    }

    @NSManaged public var iconName: String?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var transactions: NSSet?

}

// MARK: Generated accessors for transactions
extension TransactionCategory {

    @objc(addTransactionsObject:)
    @NSManaged public func addToTransactions(_ value: BalanceChange)

    @objc(removeTransactionsObject:)
    @NSManaged public func removeFromTransactions(_ value: BalanceChange)

    @objc(addTransactions:)
    @NSManaged public func addToTransactions(_ values: NSSet)

    @objc(removeTransactions:)
    @NSManaged public func removeFromTransactions(_ values: NSSet)

}

extension TransactionCategory : Identifiable {

}
