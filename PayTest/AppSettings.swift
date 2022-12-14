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
        
    static var currencies: [CurrencyML] = []
    
    // MARK: - Environment
    
    // FIXME: - For add new environment in future. dev, stage
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
        for currency in NamesofCurrencies.allCases {
            // FIXME: - Set fee for each currencies or download from DB
            let fee = Double.random(in: 0.0 ... 5.0)
            let model = CurrencyML(name: currency.rawValue, fee: fee)
            AppSettings.currencies.append(model)
        }
    }
    
    func getAuthStatus() {
        if UserDefaults.standard.getAuthenticationStatus() == false {
            for each in AppSettings.currencies {
                if each.name == NamesofCurrencies.USD.rawValue {
                    UserDefaults.setUserBalance(value: 1000.0, currency: each)
                }
            }
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
