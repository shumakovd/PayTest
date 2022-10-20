//
//  WalletML.swift
//  PayTest
//
//  Created by Shumakov Dmytro on 17.10.2022.
//

import Foundation

class WalletML: NSObject, NSCoding {
    
    // MARK: - Properties
    
    var currency: CurrencyML
    var amount: Double
    
    // MARK: - Init
    
    init(currency: CurrencyML, amount: Double) {
        self.currency = currency
        self.amount = amount
    }
    
    required init?(coder: NSCoder) {        
        self.amount = coder.decodeDouble(forKey: Keys.amount.rawValue)
        self.currency = coder.decodeObject(forKey: Keys.currency.rawValue) as? CurrencyML ?? CurrencyML(name: "", fee: 0.0)
    }
    
    // MARK: - Encode
    
    func encode(with coder: NSCoder) {
        coder.encode(amount, forKey: Keys.amount.rawValue)
        coder.encode(currency, forKey: Keys.currency.rawValue)
    }
    
    // MARK: - Methods
    
    func freeFeeExist() -> Bool {
        let freeConverters = UserDefaults.standard.getCountConverted() ?? 0
        // Do what do you want with count
        return freeConverters < 5 ? true : false
    }
    
    func isThereEnoughCash(forTheAmount: Double) -> Bool {
        return amount >= (currency.fee + forTheAmount)
    }
    
    // Decrease
    func decreaseCurrency(inTheAmountOf: Double) {
        amount -= inTheAmountOf + currency.fee
        UserDefaults.setUserBalance(value: amount, currency: currency)
    }
    
    // Increase
    func increaseCurrency(forTheAmount: Double) {
        amount += forTheAmount
        UserDefaults.setUserBalance(value: amount, currency: currency)
    }
}
