//
//  APIConfiguration.swift
//  PayTest
//
//  Created by Shumakov Dmytro on 17.10.2022.
//

import Alamofire
import Foundation

protocol APIConfiguration: URLRequestConvertible {
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: Parameters? { get }
    var encoding: Alamofire.ParameterEncoding? { get }
    var baseURL: URL? { get }
}
