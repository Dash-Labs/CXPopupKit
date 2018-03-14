//
// Created by Cunqi Xiao on 12/20/17.
// Copyright (c) 2017 Cunqi Xiao. All rights reserved.
//

import Foundation
import SnapKit

class LayoutUtil {
    static func updateFrameForInsideSafeArea(frame: CGRect?, at container: UIView, position: CXAppearance.WindowPosition) -> CGRect {
        let updatedFrame = frame ?? .zero
        var inset: UIEdgeInsets = .zero
        if #available(iOS 11.0, *) {
            inset = container.safeAreaInsets
        } else {
            return updatedFrame
        }

        switch position {
        case .center:
            return updatedFrame
        case .top:
            return CGRect(x: updatedFrame.origin.x, y: 0, width: updatedFrame.size.width, height: updatedFrame.size.height + inset.top)
        case .bottom:
            return CGRect(x: updatedFrame.origin.x, y: updatedFrame.origin.y - inset.bottom, width: updatedFrame.size.width, height: updatedFrame.size.height + inset.bottom)
        case .left:
            return CGRect(x: 0, y: updatedFrame.origin.y, width: updatedFrame.size.width + inset.left, height: updatedFrame.size.height)
        case .right:
            return CGRect(x: updatedFrame.origin.x - inset.right, y: updatedFrame.origin.y, width: updatedFrame.size.width + inset.right, height: updatedFrame.size.height)
        case .custom(let offsetX, let offsetY):
            return updatedFrame
        }
    }

    static func getEstimateHeight(for string: NSString, with width: CGFloat, and font: UIFont) -> CGFloat {
        return string.boundingRect(with: CGSize(width: Double(width), height: Double.greatestFiniteMagnitude),
                                   options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                   attributes: [NSAttributedStringKey.font: font],
                                   context: nil)
            .size.height
    }

    static func fill(view child: UIView, at parent: UIView) {
        parent.addSubview(child)
        child.snp.makeConstraints { maker in
            maker.leading.trailing.top.bottom.equalTo(parent)
        }
    }

    static func presentedViewSize(_ containerView: UIView, _ window: CXAppearance.Window, _ isSafeAreaEnabled: Bool) -> CGRect {
        let width = min(containerView.bounds.width, getLength(for: window.width, basedOn: containerView.bounds.width))
        let height = min(containerView.bounds.height, getLength(for: window.height, basedOn: containerView.bounds.height))
        let inset = getInset(from: containerView, and: window.margin, isSafeAreaEnabled: isSafeAreaEnabled)
        let X = getWindowPositionX(position: window.position, containerWidth: containerView.bounds.width, targetWidth: width, inset: inset)
        let Y = getWindowPositionY(position: window.position, containerHeight: containerView.bounds.height, targetHeight: height, inset: inset)
        return CGRect(origin: CGPoint(x: X, y: Y), size: CGSize(width: width, height: height))
    }

    private static func getInset(from containerView: UIView, and margin: UIEdgeInsets, isSafeAreaEnabled: Bool) -> UIEdgeInsets {
        if #available(iOS 11.0, *), isSafeAreaEnabled {
            let containerInset = containerView.safeAreaInsets
            return UIEdgeInsets(top: containerInset.top + margin.top, left: containerInset.left + margin.left, bottom: containerInset.top + margin.top, right: containerInset.right + margin.right)
        } else {
            return margin
        }
    }

    static func getLength(for size: CXAppearance.WindowSize, basedOn length: CGFloat) -> CGFloat {
        switch size {
        case .equalToParent:
            return length
        case .partOfParent:
            return length * size.adjustedValue
        case .fixValue:
            return size.adjustedValue
        }
    }

    // X = L + x + R
    // X: ContainerWidth,  L: insetsLeft,  x: targetWidth,  R: insetsRight
    private static func getWindowPositionX(position: CXAppearance.WindowPosition, containerWidth: CGFloat, targetWidth: CGFloat, inset: UIEdgeInsets) -> CGFloat {
        switch position {
        case .left:
            return inset.left
        case .right:
            return containerWidth - inset.left - targetWidth
        default:
            return (containerWidth - targetWidth) / 2.0
        }
    }

    // Y = T + y + B
    // Y: ContainerHeight,  T: insetsTop,  y: targetHeight,  B: insetsHeight
    private static func getWindowPositionY(position: CXAppearance.WindowPosition, containerHeight: CGFloat, targetHeight: CGFloat, inset: UIEdgeInsets) -> CGFloat {
        switch position {
        case .top:
            return inset.top
        case .bottom:
            return containerHeight - targetHeight - inset.bottom
        default:
            return (containerHeight - targetHeight) / 2.0
        }
    }


    static func install(view: UIView, into parent: UIView, inset: UIEdgeInsets) {
        parent.addSubview(view)
        view.snp.makeConstraints { maker in
            maker.edges.equalTo(parent).inset(inset)
        }
    }

    static func installWithSafeArea(view: UIView, into parent: UIView, inset: UIEdgeInsets) {
        if #available(iOS 11.0, *) {
            parent.addSubview(view)
            view.snp.makeConstraints { maker in
                maker.edges.equalTo(parent.safeAreaLayoutGuide).inset(inset)
            }
        } else {
            install(view: view, into: parent, inset: inset)
        }
    }
}
