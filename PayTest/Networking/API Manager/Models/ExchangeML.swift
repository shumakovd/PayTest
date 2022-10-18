//
//  ExchangeML.swift
//  PayTest
//
//  Created by Shumakov Dmytro on 18.10.2022.
//

import Foundation

struct ExchangeML: Codable {
    var amount: String?
    var currency: String?
    
    enum CodingKeys: String, CodingKey {
        case amount, currency
    }
}
