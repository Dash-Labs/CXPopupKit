//
//  Person.swift
//  CXPopupKitDemo
//
//  Created by Cunqi Xiao on 3/14/18.
//  Copyright © 2018 Cunqi Xiao. All rights reserved.
//

import Foundation
import CXPopupKit
struct Person: CXPickerExpressible {
    let name: String
    let age: Int

    func getCXPickerOptionName() -> String {
        return name
    }
}
