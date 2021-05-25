//
//  DetailsViewModel.swift
//  RedsoftTest
//
//  Created by Dmitry Muravev on 23.05.2021.
//

import Foundation
import RxSwift
import Action

protocol DetailsViewModelInput {
    var backAction: CocoaAction { get }
    var plusAction: CocoaAction { get }
    var minusAction: CocoaAction { get }
}

protocol DetailsViewModelOutput {
    var name: Observable<String> { get }
    var producer: Observable<String> { get }
    var price: Observable<String> { get }
    var shortDescription: Observable<String> { get }
    var productPhotoURL: Observable<URL> { get }
    var hideCartButton: BehaviorSubject<Bool> { get }
    var hideCartSelector: BehaviorSubject<Bool> { get }
    var cartText: BehaviorSubject<String> { get }
}

protocol DetailsViewModelType {
    var inputs: DetailsViewModelInput { get }
    var outputs: DetailsViewModelOutput { get }
}

final class DetailsViewModel: DetailsViewModelInput,
                              DetailsViewModelOutput,
                              DetailsViewModelType  {
    
    var inputs: DetailsViewModelInput { return self }
    var outputs: DetailsViewModelOutput { return self }
    
    private let sceneCoordinator: SceneCoordinatorType
    private let storageManager: StorageManager
    
    let name: Observable<String>
    let producer: Observable<String>
    let price: Observable<String>
    let shortDescription: Observable<String>
    let productPhotoURL: Observable<URL>
    
    let hideCartButton = BehaviorSubject<Bool>(value: false)
    let hideCartSelector = BehaviorSubject<Bool>(value: true)
    let cartText = BehaviorSubject<String>(value: "- шт")
    
    var productModel: ProductModel?
    
    lazy var backAction: CocoaAction = {
        CocoaAction { [unowned self] _ in
            self.sceneCoordinator.pop(animated: true)
        }
    }()
    
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
    
    init(productModel: ProductModel, storageManager: StorageManager = StorageManager.shared, sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared) {
        self.sceneCoordinator = sceneCoordinator
        self.storageManager = storageManager
        
        self.productModelId = productModel.id
        self.productModel = storageManager.getProduct(id: productModelId)
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
        
        shortDescription = productStream
            .map { $0.shortDescription }
            .unwrap()

        productPhotoURL = productStream
            .map { $0.imageUrl }
            .unwrap()
            .mapToURL()
        
        updateCartSelector()
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
}
