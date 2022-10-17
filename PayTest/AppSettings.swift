//
//  AppSettings.swift
//  PayTest
//
//  Created by Shumakov Dmytro on 17.10.2022.
//

import Foundation

class AppSettings {
    
    static var shared: AppSettings = {
        return AppSettings()
    }()
            
    private init() {}
    
    // MARK: - Properties
        
    static var currencies: [Currency] = []
    
    // MARK: - Environment
    
    // For add new environment in future. dev, stage
    static var env: String = "test"
    
    static var serverUrl: URL {
        switch env {
        case "test":
            return URL(string: "http://api.evp.lt/")!
        default:
            return URL(string: "http://api.evp.lt/")!
        }
    }
    
    // MARK: - Methods
    
    func loadApplicationData() {
        for currency in Currency.allCases {
            AppSettings.currencies.append(currency)
        }
        print("Currencies: ", AppSettings.currencies)
    }
    
    func getBalance() -> [WalletML] {    
        var models: [WalletML] = []
        for i in 0 ..< AppSettings.currencies.count {
            let model = WalletML(currency: AppSettings.currencies[i], count: Double(.random(in: 0 ... 1000)))
            models.append(model)
        }
        return models
    }
    
}
