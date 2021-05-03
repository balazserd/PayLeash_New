//
//  TransactionCategory+CoreDataClass.swift
//  PayLeash
//
//  Created by Balazs Erdesz on 2021. 05. 03..
//
//

import Foundation
import CoreData

@objc(TransactionCategory)
public class TransactionCategory: NSManagedObject, Codable {
    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else {
            fatalError("UserInfo did not contain the ManagedObjectContext!")
        }
        
        guard let newTransactionCategoryEntity = NSEntityDescription.entity(forEntityName: "TransactionCategory", in: context) else {
            fatalError("TransactionCategory entity could not be created!")
        }
        
        self.init(entity: newTransactionCategoryEntity, insertInto: context)
        
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        self.id = try! container.decode(UUID.self, forKey: .id)
        self.icon = try! container.decode(String.self, forKey: .icon)
        self.name = try! container.decode(String.self, forKey: .name)
        self.defaultIsMinus = try! container.decode(Bool.self, forKey: .defaultIsMinus)
        self.isUserCreated = try! container.decode(Bool.self, forKey: .isUserCreated)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try! container.encode(self.id, forKey: .id)
        try! container.encode(self.icon, forKey: .icon)
        try! container.encode(self.name, forKey: .name)
        try! container.encode(self.defaultIsMinus, forKey: .defaultIsMinus)
        try! container.encode(self.isUserCreated, forKey: .isUserCreated)
    }
    
    enum CodingKeys : CodingKey {
        case id, icon, name, defaultIsMinus, isUserCreated
    }
}
