//
//  SceneTransitionType.swift
//  RedsoftTest
//
//  Created by Dmitry Muravev on 17.05.2021.
//

import UIKit

enum SceneTransitionType {
    case root(UIViewController)
    case push(UIViewController)
    case present(UIViewController)
    case alert(UIViewController)
    case tabBar(UITabBarController)
}
