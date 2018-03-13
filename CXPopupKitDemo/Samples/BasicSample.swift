//
//  BasicSample.swift
//  CXPopupKitDemo
//
//  Created by Cunqi Xiao on 3/13/18.
//  Copyright © 2018 Cunqi Xiao. All rights reserved.
//

import UIKit
import CXPopupKit

class BasicSample: UIView {
    var appearance = CXAppearance()
}

extension BasicSample: CXPopupable {
    func createPopup() -> CXPopup {
        appearance.window.width = .fixValue(size: 300)
        appearance.window.height = .partOfParent(percent: 0.35)
        appearance.window.position = .center
        return CXPopup(with: self, appearance: appearance)
    }
}
