//
//  MenuSample.swift
//  CXPopupKitDemo
//
//  Created by Cunqi Xiao on 3/13/18.
//  Copyright © 2018 Cunqi Xiao. All rights reserved.
//

import UIKit
import CXPopupKit

class MenuSample: UIView {
    var appearance = CXAppearance()
}

extension MenuSample: CXPopupable {
    func createPopup() -> CXPopup {
        appearance.window.width = .fixValue(size: 300)
        appearance.window.height = .equalToParent
        appearance.window.position = .left
        appearance.window.maskBackgroundColor = .clear
        appearance.animation.duration = CXAnimation.Duration(0.35)
        appearance.animation.style = .fade
        appearance.animation.transition = CXAnimation.Transition(in: .right, out: .left)
        return CXPopup(with: self, appearance: appearance)
    }
}

