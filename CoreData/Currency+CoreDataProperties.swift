//
//  Currency+CoreDataProperties.swift
//  
//
//  Created by Shumakov Dmytro on 20.10.2022.
//
//

import Foundation
import CoreData


extension Currency {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Currency> {
        return NSFetchRequest<Currency>(entityName: "Currency")
    }

    @NSManaged public var fee: Double
    @NSManaged public var name: String

}
