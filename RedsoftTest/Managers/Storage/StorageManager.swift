//
//  StorageManager.swift
//  RedsoftTest
//
//  Created by Dmitry Muravev on 22.05.2021.
//

import Foundation
import RealmSwift

class StorageManager {
    static let shared = StorageManager()
    
    private let realmQueue = DispatchQueue(label: "realm_queue")
    
    private init() {
        var config = Realm.Configuration()
        config.schemaVersion = 1
        config.migrationBlock = { migration, oldSchemaVersion in
            if (oldSchemaVersion < 1) {
                
            }
        }
        Realm.Configuration.defaultConfiguration = config
    }
    
    // MARK: - Common read/write methods
    
    private func getObject<T>(block: (Realm) -> T?) -> T? {
        var object: T? = nil
        do {
            let realm = try Realm()
            object = block(realm)
        } catch {
            print("Read error: \(error)")
        }
        return object
    }
    
    func write(block: ((Realm) throws -> ())) {
        realmQueue.sync {
            do {
                let realm = try Realm()
                try realm.write {
                    do {
                        try block(realm)
                    } catch let error {
                        print("Write error: \(error)")
                    }
                }
            } catch {
                print("Write error: \(error)")
            }
        }
    }
    
    // MARK: - Read methods
    
    func getProducts() -> Results<ProductModel> {
        return getObject {
            $0.objects(ProductModel.self)
            }!.sorted(byKeyPath: "id", ascending: true)
    }
    
    func getProduct(id: Int) -> ProductModel? {
        return getObject {
            $0.object(ofType: ProductModel.self, forPrimaryKey: id)
        }
    }
    
    // MARK: - Write methods
    
    func save(object: Object, update: Bool) {
        write { realm in
            realm.add(object, update: update ? .all : .modified)
        }
    }
    
    func save(objects: [Object], update: Bool) {
        write { realm in
            realm.add(objects, update: update ? .all : .modified)
        }
    }
    
    // MARK: - Set methods
    
    func plusCartCountToProductModel(id: Int) {
        let model = getProduct(id:id)
        write { realm in
            model?.numberInCart = (model?.numberInCart ?? 0) + 1
        }
    }
    
    func minusCartCountToProductModel(id: Int) {
        let model = getProduct(id:id)
        if (model?.numberInCart ?? 0) > 0 {
            write { realm in
                model?.numberInCart = (model?.numberInCart ?? 0) - 1
            }
        }
    }
    
    
    // MARK: - Delete methods
    
    func clean() {
        write { realm in
            realm.deleteAll()
        }
    }
    
    func delete(object: Object) {
        write { realm in
            realm.delete(object)
        }
    }
    
    func delete(objects: [Object]) {
        write { realm in
            realm.delete(objects)
        }
    }
    
}

