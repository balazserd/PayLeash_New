//
//  Currency+CoreDataProperties.swift
//  PayLeash
//
//  Created by Balazs Erdesz on 2021. 03. 14..
//
//

import Foundation
import CoreData


extension Currency {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Currency> {
        return NSFetchRequest<Currency>(entityName: "Currency")
    }

    @NSManaged public var fullName: String?
    @NSManaged public var id: UUID?
    @NSManaged public var shortName: String?
    @NSManaged public var symbol: String?
    @NSManaged public var accounts: NSSet?

}

// MARK: Generated accessors for accounts
extension Currency {

    @objc(addAccountsObject:)
    @NSManaged public func addToAccounts(_ value: Account)

    @objc(removeAccountsObject:)
    @NSManaged public func removeFromAccounts(_ value: Account)

    @objc(addAccounts:)
    @NSManaged public func addToAccounts(_ values: NSSet)

    @objc(removeAccounts:)
    @NSManaged public func removeFromAccounts(_ values: NSSet)

}

extension Currency : Identifiable {

}
