//
// Created by Cunqi Xiao on 12/20/17.
// Copyright (c) 2017 Cunqi Xiao. All rights reserved.
//

import Foundation
import SnapKit

class LayoutUtil {
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

    static func presentedViewSize(`in` containerView: UIView, width: CXAppearance.WindowSize, height: CXAppearance.WindowSize, attached: CXAppearance.WindowPosition, isFollowingSafeAreaGuide: Bool, shouldFillOutSafeArea: Bool) -> CGRect {
        let shouldFollowingSafeAreaGuide: Bool

        if isFollowingSafeAreaGuide {
            shouldFollowingSafeAreaGuide = shouldFillOutSafeArea ? false : isFollowingSafeAreaGuide
        } else {
            shouldFollowingSafeAreaGuide = false
        }

        var result = CGRect.zero
        let targetInsets = convertWithSafeArea(isFollowingSafeAreaGuide: shouldFollowingSafeAreaGuide, at: containerView)

        let maximumWidth = containerView.bounds.width - targetInsets.left - targetInsets.right
        let maximumHeight = containerView.bounds.height - targetInsets.top - targetInsets.bottom

        let wo = getWidthOffset(shouldFillOutSafeArea, targetInsets, at: attached)
        let calculatedWidth = getWindowSize(size: width, for: containerView.bounds.width) + wo
        let targetWidth = calculatedWidth > maximumWidth ? maximumWidth : calculatedWidth
        let targetX = getWindowPositionX(position: attached, containerWidth: containerView.bounds.width, targetWidth: targetWidth, insetsLeft: targetInsets.left, insetsRight: targetInsets.right)

        let ho = getWidthOffset(shouldFillOutSafeArea, targetInsets, at: attached)
        let calculatedHeight = getWindowSize(size: height, for: containerView.bounds.height) + ho
        let targetHeight = calculatedHeight > maximumHeight ? maximumHeight : calculatedHeight
        let targetY = getWindowPositionY(position: attached, containerHeight: containerView.bounds.height, targetHeight: targetHeight, insetTop: targetInsets.top, insetsBottom: targetInsets.bottom)

        result.origin = CGPoint(x: targetX, y: targetY)
        result.size = CGSize(width: targetWidth, height: targetHeight)
        return result
    }

    static func getWidthOffset(_ shouldFillOutSafeArea: Bool, _ insets: UIEdgeInsets, at position: CXAppearance.WindowPosition) -> CGFloat {
        guard shouldFillOutSafeArea else {
            return 0
        }

        switch position {
            case .left:
                return insets.left
            case .right:
                return insets.right
            default:
                return 0
        }
    }

    static func getHeightOffset(_ shouldFillOutSafeArea: Bool, _ insets: UIEdgeInsets, at position: CXAppearance.WindowPosition) -> CGFloat {
        guard shouldFillOutSafeArea else {
            return 0
        }
        switch position {
            case .top:
                return insets.top
            case .bottom:
                return insets.bottom
            default:
                return 0
        }
    }

    static func convertWithSafeArea(isFollowingSafeAreaGuide: Bool, at containerView: UIView?) -> UIEdgeInsets {
        if #available(iOS 11.0, *), isFollowingSafeAreaGuide {
            return containerView?.safeAreaInsets ?? .zero
        }
        return .zero
    }

    // X = L + x + R
    // X: ContainerWidth,  L: insetsLeft,  x: targetWidth,  R: insetsRight
    private static func getWindowPositionX(position: CXAppearance.WindowPosition, containerWidth: CGFloat, targetWidth: CGFloat, insetsLeft: CGFloat, insetsRight: CGFloat) -> CGFloat {
        switch position {
            case .left:
                return insetsLeft
            case .right:
                return containerWidth - insetsRight - targetWidth
            default:
                return (containerWidth - targetWidth) / 2.0
        }
    }

    // Y = T + y + B
    // Y: ContainerHeight,  T: insetsTop,  y: targetHeight,  B: insetsHeight
    private static func getWindowPositionY(position: CXAppearance.WindowPosition, containerHeight: CGFloat, targetHeight: CGFloat, insetTop: CGFloat, insetsBottom: CGFloat) -> CGFloat {
        switch position {
            case .top:
                return insetTop
            case .bottom:
                return containerHeight - targetHeight - insetsBottom
            default:
                return (containerHeight - targetHeight) / 2.0
        }
    }

    private static func getWindowSize(size: CXAppearance.WindowSize, `for` length: CGFloat) -> CGFloat {
        switch size {
            case .equalToParent:
                return length
            case .partOfParent:
                return length * size.adjustedValue
            case .fixValue:
                return size.adjustedValue
        }

    }


    static func install(view child: UIView, at parent: UIView, attached: CXAppearance.WindowPosition, insets: UIEdgeInsets, isFollowingSafeAreaGuide: Bool) {
        parent.addSubview(child)

        child.snp.makeConstraints { maker in
            switch attached {
                case .left:
                    maker.top.bottom.trailing.equalTo(parent)
                    if #available(iOS 11.0, *), isFollowingSafeAreaGuide {
                        maker.leading.equalTo(parent.safeAreaLayoutGuide.snp.leading).offset(insets.left)
                    } else {
                        maker.leading.equalTo(parent).offset(insets.left)
                    }
                case .right:
                    maker.top.bottom.leading.equalTo(parent)
                    if #available(iOS 11.0, *), isFollowingSafeAreaGuide {
                        maker.trailing.equalTo(parent.safeAreaLayoutGuide.snp.trailing).offset(insets.left)
                    } else {
                        maker.trailing.equalTo(parent).offset(-insets.right)
                    }
                case .top:
                    maker.bottom.leading.trailing.equalTo(parent)
                    if #available(iOS 11.0, *), isFollowingSafeAreaGuide {
                        maker.top.equalTo(parent.safeAreaLayoutGuide.snp.top).offset(-insets.right)
                    } else {
                        maker.top.equalTo(parent).offset(insets.top)
                    }
                case .bottom:
                    maker.top.leading.trailing.equalTo(parent)
                    if #available(iOS 11.0, *), isFollowingSafeAreaGuide {
                        maker.bottom.equalTo(parent.safeAreaLayoutGuide.snp.bottom).offset(-insets.bottom)
                    } else {
                        maker.bottom.equalTo(parent).offset(-insets.bottom)
                    }
                default:
                    maker.leading.trailing.top.bottom.equalTo(parent)
            }
        }
    }
}
