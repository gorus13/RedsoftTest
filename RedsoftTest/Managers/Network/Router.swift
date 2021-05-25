//
//  Router.swift
//  RedsoftTest
//
//  Created by Dmitry Muravev on 17.05.2021.
//

import Foundation
import Alamofire

enum Router : URLRequestConvertible {
    
    case getProducts([String: Any])
    case getProduct
    
    private var urlEncoder: ParameterEncoding {
        return Alamofire.URLEncoding()
    }
    private var jsonEncoder: ParameterEncoding {
        return Alamofire.JSONEncoding()
    }
    
    static let baseURL = "https://rstestapi.redsoftdigital.com/api/v1"
    
    var method : Alamofire.HTTPMethod {
        switch self {
        case .getProducts(_),
             .getProduct:
            return .get
        }
    }
    
    var path : String {
        switch self {
        case .getProducts(_):
            return "/products"
        case .getProduct:
            return "/products"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        
        let requestUrl = URL(string: Router.baseURL + path)
        var request = try URLRequest(url: requestUrl!, method: method)
        
        switch self {
        case .getProducts(let params):
            request = try urlEncoder.encode(request, with: params)
            break
        default:
            break
        }
        
        //authorize
        //if (self != .silentLogin([String: Any]())) && (self != .login([String: Any]())) && (self != .refreshToken([String: Any]())) {
        //    if let accessToken = UserModel.currentUser?.token {
        //        request.setValue("JWT \(accessToken)", forHTTPHeaderField: "Authorization")
        //    }
        //}
        
        return request
    }
}
