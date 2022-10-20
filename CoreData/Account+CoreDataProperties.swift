//
//  Account+CoreDataProperties.swift
//  
//
//  Created by Shumakov Dmytro on 20.10.2022.
//
//

import Foundation
import CoreData


extension Account {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Account> {
        return NSFetchRequest<Account>(entityName: "Account")
    }

    @NSManaged public var username: String?
    @NSManaged public var wallet: NSObject?
    @NSManaged public var withWallet: Wallet?

}
