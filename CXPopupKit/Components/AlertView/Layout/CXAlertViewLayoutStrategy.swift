//
//  CXAlertViewLayoutStrategy.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 3/13/18.
//  Copyright © 2018 Cunqi Xiao. All rights reserved.
//

import UIKit
import SnapKit

protocol CXAlertViewLayoutStrategy {
    func layout(titleLabel: UILabel, at parent: UIView, alertAppearance: CXAlertAppearance) -> CGFloat
    func layout(messageLabel: UILabel, based titleLabel: UILabel, at parent: UIView, alertAppearance: CXAlertAppearance) -> CGFloat
    func layout(isVertical: Bool, actionCount: Int, stackViewBackgroundView: UIView, based detailLabel: UILabel, at parent: UIView, alertAppearance: CXAlertAppearance) -> CGFloat
}

extension CXAlertViewLayoutStrategy {
    func layout(titleLabel: UILabel, at parent: UIView, alertAppearance: CXAlertAppearance) -> CGFloat {
        if let mContent = titleLabel.text as NSString? {
            let margin = alertAppearance.dimension.titleMargin
            let width = alertAppearance.appearance.window.width.adjustedValue - margin.left - margin.right
            let titleLabelHeight = LayoutUtil.getEstimateHeight(for: mContent, with: width, and: titleLabel.font)
            titleLabel.snp.makeConstraints({ (maker) in
                maker.leading.trailing.top.equalTo(parent).inset(margin)
                maker.height.equalTo(titleLabelHeight)
            })
            return titleLabelHeight + margin.top
        } else {
            titleLabel.snp.makeConstraints({ (maker) in
                maker.leading.trailing.top.equalTo(parent)
                maker.height.equalTo(0)
            })
            return 0
        }
    }

    func layout(messageLabel: UILabel, based titleLabel: UILabel, at parent: UIView, alertAppearance: CXAlertAppearance) -> CGFloat {
        let titleMargin = alertAppearance.dimension.titleMargin
        let margin = alertAppearance.dimension.messageMargin
        let width = alertAppearance.appearance.window.width.adjustedValue - margin.left - margin.right
        if let mContent = messageLabel.text as NSString? {
            let height = LayoutUtil.getEstimateHeight(for: mContent, with: width, and: messageLabel.font)
            messageLabel.snp.makeConstraints({ (maker) in
                maker.leading.trailing.equalTo(parent).inset(margin)
                maker.top.equalTo(titleLabel.snp.bottom).offset(margin.top + titleMargin.bottom)
                maker.height.equalTo(height)
            })
            return height + margin.top + titleMargin.bottom
        } else {
            messageLabel.snp.makeConstraints({ (maker) in
                maker.leading.trailing.equalTo(parent)
                maker.top.equalTo(titleLabel.snp.bottom)
                maker.height.equalTo(0)
            })
            return 0
        }
    }
}

class CXAlertLayoutStrategy: CXAlertViewLayoutStrategy {
    func layout(isVertical: Bool, actionCount: Int, stackViewBackgroundView: UIView, based detailLabel: UILabel, at parent: UIView, alertAppearance: CXAlertAppearance) -> CGFloat {
        let messageLabelMargin = alertAppearance.dimension.messageMargin
        let height: CGFloat = isVertical ? CGFloat(actionCount) * alertAppearance.dimension.buttonHeight :  alertAppearance.dimension.buttonHeight

        stackViewBackgroundView.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(parent)
        }
        return height + messageLabelMargin.bottom
    }
}

class CXActionSheetStrategy: CXAlertViewLayoutStrategy {
    func layout(isVertical: Bool, actionCount: Int, stackViewBackgroundView: UIView, based detailLabel: UILabel, at parent: UIView, alertAppearance: CXAlertAppearance) -> CGFloat {
        let messageLabelMargin = alertAppearance.dimension.messageMargin
        let height: CGFloat = isVertical ? CGFloat(actionCount) * alertAppearance.dimension.buttonHeight :  alertAppearance.dimension.buttonHeight

        stackViewBackgroundView.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(parent)
        }
        return height + messageLabelMargin.bottom
    }
}
