//
//  Wallet+CoreDataProperties.swift
//  
//
//  Created by Shumakov Dmytro on 20.10.2022.
//
//

import Foundation
import CoreData


extension Wallet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Wallet> {
        return NSFetchRequest<Wallet>(entityName: "Wallet")
    }

    @NSManaged public var amount: Double
    @NSManaged public var currency: NSObject?
    @NSManaged public var withCurrency: NSSet?

}

// MARK: Generated accessors for withCurrency
extension Wallet {

    @objc(addWithCurrencyObject:)
    @NSManaged public func addToWithCurrency(_ value: Currency)

    @objc(removeWithCurrencyObject:)
    @NSManaged public func removeFromWithCurrency(_ value: Currency)

    @objc(addWithCurrency:)
    @NSManaged public func addToWithCurrency(_ values: NSSet)

    @objc(removeWithCurrency:)
    @NSManaged public func removeFromWithCurrency(_ values: NSSet)

}
