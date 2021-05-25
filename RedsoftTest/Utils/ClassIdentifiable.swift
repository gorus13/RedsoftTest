//
//  ClassIdentifiable.swift
//  RedsoftTest
//
//  Created by Dmitry Muravev on 22.05.2021.
//

import UIKit

protocol ClassIdentifiable: class {
    static var reuseId: String { get }
}

extension ClassIdentifiable {
    static var reuseId: String {
        return String(describing: self)
    }
}
