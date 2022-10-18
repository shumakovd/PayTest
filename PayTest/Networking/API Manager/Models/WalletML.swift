//
//  WalletML.swift
//  PayTest
//
//  Created by Shumakov Dmytro on 17.10.2022.
//

import Foundation

class WalletML {    
    var currency: Currency?
    var amount: Double?
    
    init(currency: Currency? = nil, amount: Double? = nil) {
        self.currency = currency
        self.amount = amount
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
