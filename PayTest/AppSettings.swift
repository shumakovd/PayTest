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
                
        getAuthStatus()
        setupCurrencies()
    }
    
    func setupCurrencies() {
        for currency in Currency.allCases {
            AppSettings.currencies.append(currency)
        }
    }
      
    
    func getAuthStatus() {
        if UserDefaults.standard.getAuthenticationStatus() == false {
            UserDefaults.setUserBalance(value: 1000.0, currency: .EUR)
            UserDefaults.standard.setAuthenticationStatus(true)
        }
    }
    
    func getBalance() -> [WalletML] {
        var balance: [WalletML] = []
                        
        for i in 0 ..< AppSettings.currencies.count {
            let currency = AppSettings.currencies[i]
            let amount = UserDefaults.getUserBalance(for: currency)
            let model = WalletML(currency: currency, amount: amount)
            balance.append(model)
        }    
        
        return balance
    }
}
