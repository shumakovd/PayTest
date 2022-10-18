//
//  WalletML.swift
//  PayTest
//
//  Created by Shumakov Dmytro on 17.10.2022.
//

import Foundation

class WalletML {    
    var currency: Currency
    var amount: Double
    
    init(currency: Currency, amount: Double) {
        self.currency = currency
        self.amount = amount
    }
    
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

class Fee {
    var currency: Currency?
    var fee: Double?
    
    init(currency: Currency? = nil, fee: Double? = nil) {
        self.currency = currency
        self.fee = fee
    }
}
