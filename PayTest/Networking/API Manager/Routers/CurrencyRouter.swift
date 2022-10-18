//
//  CurrencyRouter.swift
//  PayTest
//
//  Created by Shumakov Dmytro on 18.10.2022.
//

import Alamofire
import Foundation

enum CurrencyEndpoint {
    case exchange(fromAmount: Double, fromCurrency: NamesofCurrencies, toCurrency: NamesofCurrencies)
}

class CurrencyRouter: BaseRouter {
    
    fileprivate var endPoint: CurrencyEndpoint

    init(anEndpoint: CurrencyEndpoint) {
        endPoint = anEndpoint
    }
    //
    override var method: HTTPMethod {
        switch endPoint {
        case .exchange:
            return .get
        }
    }
    //
    override var path: String {
        switch endPoint {
        case let .exchange(fromAmount, fromCurrency, toCurrency):
            return "currency/commercial/exchange/\(fromAmount)-\(fromCurrency)/\(toCurrency)/latest"
            // http://api.evp.lt/currency/commercial/exchange/{fromAmount}-{fromCurrency}/{toCurrency}/latest
        }
    }
    //
    override var parameters: Parameters? {
        switch endPoint {
        case .exchange:
            return nil
        }
    }
    //
    override var keyPath: String? {
        return nil
    }
    //
    override var encoding: ParameterEncoding? {
        switch method {
        case .get:
            return JSONEncoding.default
        default:
            return JSONEncoding.default
        }
    }
    //
    override var baseURL: URL? {
        switch endPoint {
        case .exchange:
            return AppSettings.serverUrl
        }
    }
}
