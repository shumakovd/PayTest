//
//  NetworkStatus.swift
//  PayTest
//
//  Created by Shumakov Dmytro on 17.10.2022.
//

import Alamofire
import Foundation

class NetworkStatus {
    static let sharedInstance = NetworkStatus()

    private init() {}

    /// USAGE:
    /// if NetworkStatus.isConnectedToInternet() {
    ///    true
    /// }
    class func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}

