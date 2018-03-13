//
//  CXLifecycleAction.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 3/13/18.
//  Copyright © 2018 Cunqi Xiao. All rights reserved.
//

import Foundation

public protocol CXLifecycleAction {
    func popupWindowDidLoad()
    func popupWindowWillAppear()
    func popupWindowDidAppear()
    func popupWindowWillDisappear()
    func popupWindowDidDisappear()
}

public extension CXLifecycleAction {
    func popupWindowDidLoad() {}
    func popupWindowWillAppear() {}
    func popupWindowDidAppear() {}
    func popupWindowWillDisappear() {}
    func popupWindowDidDisappear() {}
}
