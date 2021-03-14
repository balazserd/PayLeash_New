//
//  BalanceChange+CoreDataProperties.swift
//  PayLeash
//
//  Created by Balazs Erdesz on 2021. 03. 14..
//
//

import Foundation
import CoreData


extension BalanceChange {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BalanceChange> {
        return NSFetchRequest<BalanceChange>(entityName: "BalanceChange")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var time: Date?
    @NSManaged public var title: String?
    @NSManaged public var amount: Double
    @NSManaged public var account: Account?
    @NSManaged public var category: TransactionCategory?

}

extension BalanceChange : Identifiable {

}
