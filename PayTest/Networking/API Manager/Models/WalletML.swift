//
//  WalletML.swift
//  PayTest
//
//  Created by Shumakov Dmytro on 17.10.2022.
//

import Foundation

class WalletML {
    
    var currency: Currency?
    var count: Double?
    
    init(currency: Currency? = nil, count: Double? = nil) {
        self.currency = currency
        self.count = count
    }
    
}
