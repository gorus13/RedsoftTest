//
//  ProductModel.swift
//  RedsoftTest
//
//  Created by Dmitry Muravev on 17.05.2021.
//

import RealmSwift
import ObjectMapper

class ProductModel: Object, Mappable {

    @objc dynamic var id = 0
    @objc dynamic var title = ""
    @objc dynamic var imageUrl = ""
    @objc dynamic var producer = ""
    @objc dynamic var price = 0
    @objc dynamic var shortDescription = ""
    
    @objc dynamic var numberInCart = 0

    override class func primaryKey() -> String? {
        return "id"
    }

    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        imageUrl <- map["image_url"]
        producer <- map["producer"]
        price <- map["price"]
        shortDescription <- map["short_description"]
    }
}
