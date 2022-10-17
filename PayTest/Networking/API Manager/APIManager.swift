//
//  APIManager.swift
//  PayTest
//
//  Created by Shumakov Dmytro on 17.10.2022.
//

import Alamofire
import CodableAlamofire
import Foundation

final class APIManager {
    
    /// The static field that controls the access to the singleton instance.
    /// This implementation let you extend the Singleton class while keeping
    /// just one instance of each subclass around.
    static var shared: APIManager = {
        return APIManager()
    }()
    
    private init() {}
    
    enum Result<T> {
        case success(T)
        case failure(String)
    }
    
    enum ResultNoResponse {
        case success
        case failure(String)
    }
    
    // MARK: - Properties -
    
    private let failureNoInternet = "No Internet. Please, make sure you are connected and try again."
    
    private let manager: Alamofire.Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 60
        return Alamofire.Session(configuration: configuration)
    }()
    
    // http://api.evp.lt/currency/commercial/exchange/{fromAmount}-{fromCurrency}/{toCurrency}/latest
    
    private func performRequest<T: Codable>(router: BaseRouter, needToChangeDecoder: Bool = false, completion: @escaping (Result<T>) -> Void) {
        if NetworkStatus.isConnectedToInternet() {
            completion(.failure(failureNoInternet))
        }
        
        let decoder = JSONDecoder()
        if needToChangeDecoder {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            formatter.locale = Locale(identifier: "en_US_POSIX")
            decoder.dateDecodingStrategy = .formatted(formatter)
        } else {
            decoder.dateDecodingStrategy = .secondsSince1970
        }
        
//        manager.request(router).validate().responseDecodableObject(keyPath: router.keyPath, decoder: decoder) { (response: DataResponse<T>) in
//            print("Result: \(String(describing: response.response))")
//
//        }


    }
    
    

    
}
