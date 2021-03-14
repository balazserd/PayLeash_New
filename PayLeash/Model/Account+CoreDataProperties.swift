//
//  Account+CoreDataProperties.swift
//  PayLeash
//
//  Created by Balazs Erdesz on 2021. 03. 14..
//
//

import Foundation
import CoreData


extension Account {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Account> {
        return NSFetchRequest<Account>(entityName: "Account")
    }

    @NSManaged public var bankName: String?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var number: String?
    @NSManaged public var currency: Currency?
    @NSManaged public var transactions: Set<BalanceChange>?

}

// MARK: Generated accessors for transactions
extension Account {

    @objc(addTransactionsObject:)
    @NSManaged public func addToTransactions(_ value: BalanceChange)

    @objc(removeTransactionsObject:)
    @NSManaged public func removeFromTransactions(_ value: BalanceChange)

    @objc(addTransactions:)
    @NSManaged public func addToTransactions(_ values: NSSet)

    @objc(removeTransactions:)
    @NSManaged public func removeFromTransactions(_ values: NSSet)

}

extension Account : Identifiable {

}
