//
//  DataManager.swift
//  RedsoftTest
//
//  Created by Dmitry Muravev on 22.05.2021.
//

import Foundation
import RealmSwift

class DataManager {
    
    static let shared = DataManager()

    private init() {
    }
    
    func getProducts(offset: Int, complete: (([ProductModel]?, _ error: Error?) -> ())?) {

        ApiManager.shared.getProducts(offset: offset){ (productModelArray, error) in
            if error == nil {

                StorageManager.shared.save(objects: productModelArray!, update: false)

                let products = StorageManager.shared.getProducts()
                complete?(products.toArray(), nil)
            } else {
                complete?(nil, error)
            }
        }

        let products = StorageManager.shared.getProducts()
        complete?(products.toArray(), nil)
    }
    
    func getProducts(filter: String, complete: (([ProductModel]?, _ error: Error?) -> ())?) {

        ApiManager.shared.getProducts(filter: filter){ (productModelArray, error) in
            if error == nil {
                complete?(productModelArray, nil)
            } else {
                complete?(nil, error)
            }
        }
    }
}

