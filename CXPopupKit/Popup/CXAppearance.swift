//
//  CXAppearance.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 12/18/17.
//  Copyright © 2017 Cunqi Xiao. All rights reserved.
//

import Foundation

public struct CXAppearance {
    public init() {}
    
    // Shadow
    public struct Shadow {
        public var isEnabled = true
        public var radius: CGFloat = 2.0
        public var opacity: Float = 0.5
        public var offset: CGSize = CGSize(width: 1.0, height: 1.0)
        public var color: UIColor = .black
    }

    public struct Window {
        public var width: WindowSize = .equalToParent
        public var height: WindowSize = .equalToParent
        public var margin: UIEdgeInsets = .zero
        public var position: WindowPosition = .center
        public var isSafeAreaEnabled: Bool = true
        public var allowTouchOutsideToDismiss = true
        public var maskBackgroundColor: UIColor = .black
        public var maskBackgroundAlpha: CGFloat = 0.3
    }

    public struct Orientation {
        public var isAutoRotationEnabled = false
        public var supportedInterfaceOrientations: UIInterfaceOrientationMask = .all
        public var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation = .portrait
    }

    public enum WindowPosition {
        case center
        case left
        case right
        case bottom
        case top
        case custom(offsetX: CGFloat, offsetY: CGFloat)
    }

    public enum WindowSize {
        case equalToParent
        case partOfParent(percent: CGFloat)
        case fixValue(size: CGFloat)

        var adjustedValue: CGFloat {
            switch self {
                case .equalToParent:
                    return 0
                case let .partOfParent(percent):
                    return percent <= 0 ? 0 : percent >= 1 ? 1 : percent
                case let .fixValue(size):
                    return size <= 0 ? 0 : size
            }
        }
    }

    public var animation = CXAnimation()
    public var window = Window()
    public var shadow = Shadow()
    public var orientation = Orientation()
}


