//
//  ApiManager.swift
//  RedsoftTest
//
//  Created by Dmitry Muravev on 17.05.2021.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import SwiftyJSON

class ApiManager {
    
    static let shared = ApiManager()
    private init() {}
    
    typealias ErrorCompletion = (Error?, String?) -> Void

    typealias ProductsCompletion = ([ProductModel]?, Error?) -> Void
    
    func getProducts(offset: Int, completion: @escaping ProductsCompletion) {
        
        let params: [String: Any] = ["startFrom": offset, "sort":  "id"]
        
        AF.request(Router.getProducts(params))
            .validate(statusCode: 200..<300)
            .responseArray(keyPath: "data") { (response: AFDataResponse<[ProductModel]>) in
                
                if let item = response.value {
                    completion(item, nil)
                } else {
                    //response.logError()
                    completion(nil, response.error)
                }
        }
    }
    
    func getProducts(filter: String, completion: @escaping ProductsCompletion) {
        
        let params = ["filter[title]" : filter, "sort":  "id"]
        
        AF.request(Router.getProducts(params))
            .validate(statusCode: 200..<300)
            .responseArray(keyPath: "data") { (response: AFDataResponse<[ProductModel]>) in
                
                if let item = response.value {
                    completion(item, nil)
                } else {
                    //response.logError()
                    completion(nil, response.error)
                }
        }
    }
    
}

