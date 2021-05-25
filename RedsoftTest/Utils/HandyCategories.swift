//
//  HandyCategories.swift
//  RedsoftTest
//
//  Created by Dmitry Muravev on 24.05.2021.
//

import Foundation
import RealmSwift

extension Results {
    func toArray() -> [Element] {
      return compactMap {
        $0
      }
    }
 }
