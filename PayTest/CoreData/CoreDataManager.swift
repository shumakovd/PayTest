//
//  CoreDataManager.swift
//  PayTest
//
//  Created by Shumakov Dmytro on 19.10.2022.
//

import UIKit
import CoreData
import Foundation

class CoreDataManager {
            
    // Shared Instance
    static let shared: CoreDataManager = {
        return CoreDataManager()
    }()
    private init() {}
    
    // Persistent Container
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PayTest")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // Core Data Methods
    
//    lazy var persistentContainer: NSPersistentCloudKitContainer = {
//        /*
//         The persistent container for the application. This implementation
//         creates and returns a container, having loaded the store for the
//         application to it. This property is optional since there are legitimate
//         error conditions that could cause the creation of the store to fail.
//        */
//        let container = NSPersistentCloudKitContainer(name: "PayTest")
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//
//                /*
//                 Typical reasons for an error here include:
//                 * The parent directory does not exist, cannot be created, or disallows writing.
//                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
//                 * The device is out of space.
//                 * The store could not be migrated to the current model version.
//                 Check the error message to determine what the actual problem was.
//                 */
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//        return container
//    }()
    
    // Save Context
    
//    func saveContext () {
//        let context = CoreDataManager.shared.persistentContainer.viewContext
//        if context.hasChanges {
//            do {
//                try context.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//            }
//        }
//    }
//
//    func insertPerson(name: String, ssn : Int16) -> String? {
//        //
//        let managedContext = CoreDataManager.shared.persistentContainer.viewContext
//
//        // NSEntityDescription is a description of an entity in Core Data.
//        let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)!
//
//        // Initializes a managed object and inserts it into the specified managed object context.
//        let person = NSManagedObject(entity: entity, insertInto: managedContext)
//
//        /*
//         With an NSManagedObject in hand, you set the name attribute using key-value coding. You must spell the KVC key (name in this case) exactly as it appears in your Data Model
//         */
//        person.setValue(name, forKeyPath: "name")
//        person.setValue(ssn, forKeyPath: "ssn")
//
//        do {
//            try managedContext.save()
//            return person as? String
//        } catch let error as NSError {
//            print("Could not save. \(error), \(error.userInfo)")
//            return nil
//        }
//    }
//
//    func update(name:String, ssn : Int16, person: String) {
//
//        /*1.
//         Before you can save or retrieve anything from your Core Data store, you first need to get your hands on an NSManagedObjectContext. You can consider a managed object context as an in-memory “scratchpad” for working with managed objects.
//         Think of saving a new managed object to Core Data as a two-step process: first, you insert a new managed object into a managed object context; then, after you’re happy with your shiny new managed object, you “commit” the changes in your managed object context to save it to disk.
//         Xcode has already generated a managed object context as part of the new project’s template. Remember, this only happens if you check the Use Core Data checkbox at the beginning. This default managed object context lives as a property of the NSPersistentContainer in the application delegate. To access it, you first get a reference to the app delegate.
//         */
//        let context = CoreDataManager.shared.persistentContainer.viewContext
//
//        do {
//
//          /*
//           With an NSManagedObject in hand, you set the name attribute using key-value coding. You must spell the KVC key (name in this case) exactly as it appears in your Data Model
//           */
//          person.setValue(name, forKey: "name")
//          person.setValue(ssn, forKey: "ssn")
//
//          print("\(person.value(forKey: "name"))")
//          print("\(person.value(forKey: "ssn"))")
//
//          /*
//           You commit your changes to person and save to disk by calling save on the managed object context. Note save can throw an error, which is why you call it using the try keyword within a do-catch block. Finally, insert the new managed object into the people array so it shows up when the table view reloads.
//           */
//          do {
//            try context.save()
//            print("saved!")
//          } catch let error as NSError  {
//            print("Could not save \(error), \(error.userInfo)")
//          } catch {
//
//          }
//
//        } catch {
//          print("Error with request: \(error)")
//        }
//      }
    
    func saveContext () {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // Set
    
    func account(username: String, wallet: WalletML) -> Account {
        let account = Account(context: persistentContainer.viewContext)
        account.username = username
        account.wallet = wallet
        return account
    }
    
    func wallet(amount: Double, currency: CurrencyML) -> Wallet {
        let wallet = Wallet(context: persistentContainer.viewContext)
        wallet.amount = amount
        wallet.currency = currency
        return wallet
    }
    
    func currency(fee: Double, name: String) -> Currency {
        let currency = Currency(context: persistentContainer.viewContext)
        currency.fee = fee
        currency.name = name
        return currency
    }
    
    // Fetch
    
    func accounts() -> [Account] {
        let request: NSFetchRequest<Account> = Account.fetchRequest()
        var fetchedAccounts: [Account] = []
        do {
            fetchedAccounts = try persistentContainer.viewContext.fetch(request)
        } catch let error {
            print("Error fetching singers \(error)")
        }
        return fetchedAccounts
    }
    
    func wallets() -> [Wallet] {
        let request: NSFetchRequest<Wallet> = Wallet.fetchRequest()
        var fetchedWallets: [Wallet] = []
        do {
            fetchedWallets = try persistentContainer.viewContext.fetch(request)
        } catch let error {
            print("Error fetching singers \(error)")
        }
        return fetchedWallets
    }
    
    func currencies() -> [Currency] {
        let request: NSFetchRequest<Currency> = Currency.fetchRequest()
        var fetchedCurrencies: [Currency] = []
        do {
            fetchedCurrencies = try persistentContainer.viewContext.fetch(request)
        } catch let error {
            print("Error fetching singers \(error)")
        }
        return fetchedCurrencies
    }
    
    // Delete Data
    
    func deleteAccount(account: Account) {
        let context = persistentContainer.viewContext
        context.delete(account)
        saveContext()
    }
    
    func deleteWallet(wallet: Account) {
        let context = persistentContainer.viewContext
        context.delete(wallet)
        saveContext()
    }
    
    func deleteCurrency(currency: Account) {
        let context = persistentContainer.viewContext
        context.delete(currency)
        saveContext()
    }    
}
