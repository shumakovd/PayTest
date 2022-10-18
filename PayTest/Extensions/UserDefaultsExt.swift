//
//  UserDefaultsExt.swift
//  PayTest
//
//  Created by Shumakov Dmytro on 18.10.2022.
//

import Foundation

struct UserDefaultsStruct {
    static let userBalance = "user_balance_key"
    static let userAuthentication = "user_auth_key"
}

extension UserDefaults {
    
    // AUTHENTICATION
    
    func setAuthenticationStatus(_ status: Bool) {
        set(status, forKey: UserDefaultsStruct.userAuthentication)
        synchronize()
    }

    func getAuthenticationStatus() -> Bool? {
        return UserDefaults.standard.bool(forKey: UserDefaultsStruct.userAuthentication)
    }
    
    // BALANCE
        
    static func setUserBalance(value: Double, currency: Currency) {
        let defaults = UserDefaults(suiteName: UserDefaultsStruct.userBalance)
        defaults?.set(value, forKey: currency.rawValue)
    }
    
    static func getUserBalance(for currency: Currency) -> Double {
        let defaults = UserDefaults(suiteName: UserDefaultsStruct.userBalance)
        let value = defaults?.object(forKey: currency.rawValue) as? Double
        return value ?? 0.0
    }
}