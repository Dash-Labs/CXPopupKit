//
//  CXPopupable.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 3/8/18.
//  Copyright © 2018 Cunqi Xiao. All rights reserved.
//

import UIKit

public protocol CXPopupable: CXLifecycleAction  where Self: UIView {
    var popup: CXPopup? { get }
    func createPopup() -> CXPopup
    func createPopup(_ appearance: CXAppearance) -> CXPopup
}

extension CXPopupable {
    public func createPopup() -> CXPopup {
        return CXPopup(with: self, appearance: CXAppearance())
    }

    public func createPopup(_ appearance: CXAppearance) -> CXPopup {
        return CXPopup(with: self, appearance: appearance)
    }

    public var popup: CXPopup? {
        var responder: UIResponder? = self
        while responder != nil {
            responder = responder?.next
            if let window = responder as? CXPopupWindow {
                return window.holder
            }
        }
        return nil
    }
}
