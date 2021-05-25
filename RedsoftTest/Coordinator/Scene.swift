//
//  Scene.swift
//  RedsoftTest
//
//  Created by Dmitry Muravev on 17.05.2021.
//

import UIKit

protocol TargetScene {
    var transition: SceneTransitionType { get }
}

enum Scene {
    case products
    case details(ProductModel)
}

extension Scene: TargetScene {
    var transition: SceneTransitionType {
        switch self {
        case .products:
            var vc = ProductsViewController.initFromNib()
            let rootViewController = UINavigationController(rootViewController: vc)
            rootViewController.isNavigationBarHidden = true
            let productsViewModel = ProductsViewModel()
            vc.bind(to: productsViewModel)
            return .root(rootViewController)
        case let .details(productModel):
            var vc = DetailsViewController.initFromNib()
            let detailsViewModel = DetailsViewModel(productModel: productModel)
            vc.bind(to: detailsViewModel)
            return .present(vc)
        }
    }
}


