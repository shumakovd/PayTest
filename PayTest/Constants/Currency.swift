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

class Currency {
    var name: NamesofCurrencies
    var fee: Double
    
    init(name: NamesofCurrencies, fee: Double) {
        self.name = name
        self.fee = fee
    }
    
    func getActualFees(amount: Double) -> Double {
        return amount * fee
    }        
}
