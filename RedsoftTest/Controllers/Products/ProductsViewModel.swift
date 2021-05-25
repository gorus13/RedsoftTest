//
//  ProductsViewModel.swift
//  RedsoftTest
//
//  Created by Dmitry Muravev on 22.05.2021.
//

//
//  InputScreenViewModel.swift
//  SredaTest
//
//  Created by Dmitry Muravev on 18.05.2021.
//

import Foundation
import RxSwift
import Action

protocol ProductsViewModelInput {
    var loadMore: BehaviorSubject<Bool> { get }
    var productDetailsAction: Action<ProductModel, Void> { get }
    var search: BehaviorSubject<String> { get }
    var backAction: CocoaAction { get }
}

protocol ProductsViewModelOutput {
    var productsViewModel: Observable<[ProductsTableViewCellModelType]> { get }
    var searchSet: BehaviorSubject<String> { get }
}

protocol ProductsViewModelType {
    var inputs: ProductsViewModelInput { get }
    var outputs: ProductsViewModelOutput { get }
}

final class ProductsViewModel: ProductsViewModelInput,
                               ProductsViewModelOutput,
                               ProductsViewModelType  {
    
    var inputs: ProductsViewModelInput { return self }
    var outputs: ProductsViewModelOutput { return self }
    
    private let sceneCoordinator: SceneCoordinatorType
    private let storageManager: StorageManager
    
    let loadMore = BehaviorSubject<Bool>(value: false)
    
    lazy var productDetailsAction: Action<ProductModel, Void> = {
        return Action<ProductModel, Void> { [unowned self] product in
            return self.sceneCoordinator.transition(to: Scene.details(product))
        }
    }()
    
    lazy var productsViewModel: Observable<[ProductsTableViewCellModelType]> = {
        return Observable.combineLatest(productModels, searchQuery)
            .map { productModels, searchQuery in
                productModels.map { ProductsTableViewCellModel.init(productModel: $0) }
            }
    }()
    
    lazy var backAction: CocoaAction = {
        CocoaAction { [unowned self] _ in
            let models:[ProductModel]?  = Array(StorageManager.shared.getProducts())
            self.productModels.onNext(models ?? [])
            self.searchSet.onNext("")
            return .empty()
        }
    }()

    let search = BehaviorSubject<String>(value: "")
    let searchSet = BehaviorSubject<String>(value: "")
    
    let searchQuery: Observable<String>
    private var productModels = BehaviorSubject<[ProductModel]>(value: [])
    
    var curOffset = 0

    init( storageManager: StorageManager = StorageManager.shared, sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared) {
        self.sceneCoordinator = sceneCoordinator
        self.storageManager = storageManager
        
        self.searchQuery = Observable.just("")
        
        search.subscribe(onNext: { [weak self] value in
            if value.isEmpty {
                self?.productModels.onNext(storageManager.getProducts().toArray())
            } else {
                DataManager.shared.getProducts(filter: value) { [weak self] (models, error) in
                    self?.curOffset = models?.count ?? 0
                    self?.productModels.onNext(models ?? [])
                }
            }
        })
        
        loadMore.subscribe(onNext: { [weak self] value in
            DataManager.shared.getProducts(offset: self?.curOffset ?? 0) { [weak self] (models, error) in
                self?.curOffset = models?.count ?? 0
                self?.productModels.onNext(models ?? [])
            }
        })
     
    }
}

