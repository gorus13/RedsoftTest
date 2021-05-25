//
//  SceneCoordinatorType.swift
//  RedsoftTest
//
//  Created by Dmitry Muravev on 17.05.2021.
//

import UIKit
import RxSwift

protocol SceneCoordinatorType {
    init(window: UIWindow)
    
    @discardableResult func transition(to scene: TargetScene) -> Observable<Void>
    @discardableResult func pop(animated: Bool) -> Observable<Void>
}
