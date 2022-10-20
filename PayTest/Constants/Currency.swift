//
//  Currencies.swift
//  PayTest
//
//  Created by Shumakov Dmytro on 17.10.2022.
//

import Foundation

// FIXME: - Add Currency Simple

enum NamesofCurrencies: String, CaseIterable {
    case EUR, USD, JPY
}

enum Keys: String {
    case name, fee, username, currency, amount
}

class CurrencyML: NSObject, NSCoding {
    
    var fee: Double
    var name: String
    
    init(name: String, fee: Double) {
        self.name = name
        self.fee = fee
    }
    
    required init?(coder: NSCoder) {
        self.fee = coder.decodeDouble(forKey: Keys.fee.rawValue)        
        self.name = coder.decodeObject(forKey: Keys.name.rawValue) as? String ?? ""
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(fee, forKey: Keys.fee.rawValue)
        coder.encode(name, forKey: Keys.name.rawValue)
    }
    
    func getActualFees(amount: Double) -> Double {
        return amount * fee
    }

}
