//
//  ProductsTableViewCellModel.swift
//  RedsoftTest
//
//  Created by Dmitry Muravev on 22.05.2021.
//

import Foundation
import RxSwift
import Action
import RealmSwift

protocol ProductsTableViewCellModelInput {
    var plusAction: CocoaAction { get }
    var minusAction: CocoaAction { get }
}

protocol ProductsTableViewCellModelOutput {
    var category: Observable<String> { get }
    var name: Observable<String> { get }
    var producer: Observable<String> { get }
    var price: Observable<String> { get }
    var productPhotoURL: Observable<URL> { get }
    var hideCartButton: BehaviorSubject<Bool> { get }
    var hideCartSelector: BehaviorSubject<Bool> { get }
    var cartText: BehaviorSubject<String> { get }
}

protocol ProductsTableViewCellModelType {
    var inputs: ProductsTableViewCellModelInput { get }
    var outputs: ProductsTableViewCellModelOutput { get }
}

final class ProductsTableViewCellModel: ProductsTableViewCellModelType, ProductsTableViewCellModelInput, ProductsTableViewCellModelOutput {

    var inputs: ProductsTableViewCellModelInput { return self }
    var outputs: ProductsTableViewCellModelOutput { return self }

    let category: Observable<String>
    let name: Observable<String>
    let producer: Observable<String>
    let price: Observable<String>
    let productPhotoURL: Observable<URL>
    
    let hideCartButton = BehaviorSubject<Bool>(value: false)
    let hideCartSelector = BehaviorSubject<Bool>(value: true)
    let cartText = BehaviorSubject<String>(value: "- шт")
    
    var realmNotificationToken: NotificationToken?
    
    lazy var plusAction: CocoaAction = {
        CocoaAction { [unowned self] _ in
            StorageManager.shared.plusCartCountToProductModel(id: self.productModelId)
            self.updateCartSelector()
            return .empty()
        }
    }()
    
    lazy var minusAction: CocoaAction = {
        CocoaAction { [unowned self] _ in
            StorageManager.shared.minusCartCountToProductModel(id: self.productModelId)
            self.updateCartSelector()
            return .empty()
        }
    }()
    
    var productModelId: Int!
    var productModel: ProductModel?
    
    init(productModel: ProductModel) {
        self.productModelId = productModel.id
        self.productModel = StorageManager.shared.getProduct(id: productModelId)
        let productStream = Observable.just(self.productModel ?? productModel)

        name = productStream
            .map { $0.title }
            .unwrap()
        
        producer = productStream
            .map { $0.producer }
            .unwrap()
        
        price = productStream
            .map { "\($0.price) ₽" }
            .unwrap()
        
        category = productStream
            .map { $0.title }
            .unwrap()

        productPhotoURL = productStream
            .map { $0.imageUrl }
            .unwrap()
            .mapToURL()
        
        updateCartSelector()
        
        realmNotificationToken = self.productModel?.observe { [weak self] _ in
            self?.updateCartSelector()
        }
    }
    
    func updateCartSelector() {
        let product = StorageManager.shared.getProduct(id: self.productModelId)
        if (product?.numberInCart ?? 0) > 0 {
            hideCartSelector.onNext(false)
            hideCartButton.onNext(true)
            cartText.onNext("\(product?.numberInCart ?? 0) шт")
        } else {
            hideCartSelector.onNext(true)
            hideCartButton.onNext(false)
        }
    }
    
    deinit {
        realmNotificationToken?.invalidate()
    }
}
