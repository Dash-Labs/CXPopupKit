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

    static func presentedViewSize(`in` containerView: UIView, width: CXAppearance.WindowSize, height: CXAppearance.WindowSize, attached: CXAppearance.WindowPosition, insets: UIEdgeInsets, isFollowingSafeAreaGuide: Bool) -> CGRect {
        var result = CGRect.zero

        let targetInsets = convertWithSafeArea(insets: insets, isFollowingSafeAreaGuide: isFollowingSafeAreaGuide, at: containerView)

        let targetWidth = getWindowSize(size: width, for: containerView.bounds.width)
        let targetX = getWindowPositionX(position: attached, containerWidth: containerView.bounds.width, targetWidth: targetWidth, insetsLeft: targetInsets.left, insetsRight: targetInsets.right)

        let targetHeight = getWindowSize(size: height, for: containerView.bounds.height)
        let targetY = getWindowPositionY(position: attached, containerHeight: containerView.bounds.height, targetHeight: targetHeight, insetTop: targetInsets.top, insetsBottom: targetInsets.bottom)


        result.origin = CGPoint(x: targetX, y: targetY)
        result.size = CGSize(width: targetWidth, height: targetHeight)
        return result
    }

    private static func convertWithSafeArea(insets: UIEdgeInsets, isFollowingSafeAreaGuide: Bool, at containerView: UIView) -> UIEdgeInsets {
        if #available(iOS 11.0, *), isFollowingSafeAreaGuide {
            let safeArea = containerView.safeAreaInsets
            return UIEdgeInsets(top: insets.top + safeArea.top, left: insets.left + safeArea.left, bottom: insets.bottom + safeArea.bottom, right: insets.right + safeArea.right)
        }
        return insets
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


    static func install(view child: UIView, at parent: UIView, width: CXAppearance.WindowSize, height: CXAppearance.WindowSize, attached: CXAppearance.WindowPosition, insets: UIEdgeInsets, isFollowingSafeAreaGuide: Bool) {
        parent.addSubview(child)

        child.snp.makeConstraints { maker in

            switch width {
                case .equalToParent:
                    maker.width.equalTo(parent)
                case .partOfParent:
                    maker.width.equalTo(parent).multipliedBy(width.adjustedValue)
                case .fixValue:
                    maker.width.equalTo(width.adjustedValue)
            }

            switch height {
                case .equalToParent:
                    maker.height.equalTo(parent)
                case .partOfParent:
                    maker.height.equalTo(parent).multipliedBy(height.adjustedValue)
                case .fixValue:
                    maker.height.equalTo(height.adjustedValue)
            }

            switch attached {
                case .center:
                    maker.center.equalTo(parent)
                case .left:
                    maker.centerY.equalTo(parent)
                    if #available(iOS 11.0, *), isFollowingSafeAreaGuide {
                        maker.leading.equalTo(parent.safeAreaLayoutGuide.snp.leading).offset(insets.left)
                    } else {
                        maker.leading.equalTo(parent).offset(insets.left)
                    }
                case .right:
                    maker.centerY.equalTo(parent)
                    if #available(iOS 11.0, *), isFollowingSafeAreaGuide {
                        maker.trailing.equalTo(parent.safeAreaLayoutGuide.snp.trailing).offset(insets.left)
                    } else {
                        maker.trailing.equalTo(parent).offset(-insets.right)
                    }
                case .top:
                    maker.centerX.equalTo(parent)
                    if #available(iOS 11.0, *), isFollowingSafeAreaGuide {
                        maker.top.equalTo(parent.safeAreaLayoutGuide.snp.top).offset(-insets.right)
                    } else {
                        maker.top.equalTo(parent).offset(insets.top).offset(-insets.right)
                    }
                case .bottom:
                    maker.centerX.equalTo(parent)
                    if #available(iOS 11.0, *), isFollowingSafeAreaGuide {
                        maker.bottom.equalTo(parent.safeAreaLayoutGuide.snp.bottom).offset(-insets.bottom)
                    } else {
                        maker.bottom.equalTo(parent).offset(-insets.bottom)
                    }
                case let .custom(x, y):
                    if #available(iOS 11.0, *), isFollowingSafeAreaGuide {
                        maker.leading.equalTo(parent.safeAreaLayoutGuide.snp.leading).offset(x)
                    } else {
                        maker.leading.equalTo(parent).offset(x)
                    }

                    if #available(iOS 11.0, *), isFollowingSafeAreaGuide {
                        maker.top.equalTo(parent.safeAreaLayoutGuide.snp.top).offset(y)
                    } else {
                        maker.top.equalTo(parent).offset(y)
                    }
            }
        }
    }
}
