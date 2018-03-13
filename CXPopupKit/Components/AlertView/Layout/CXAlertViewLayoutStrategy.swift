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
    func layout(actionButtons: [UIButton], to stackView: UIStackView, based detailLabel: UILabel, at: UIView, alertAppearance: CXAlertAppearance) -> CGFloat
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
            return titleLabelHeight + margin.top + margin.bottom
        } else {
            titleLabel.snp.makeConstraints({ (maker) in
                maker.leading.trailing.top.equalTo(parent)
                maker.height.equalTo(0)
            })
            return 0
        }
    }

    func layout(messageLabel: UILabel, based titleLabel: UILabel, at parent: UIView, alertAppearance: CXAlertAppearance) -> CGFloat {
        let margin = alertAppearance.dimension.messageMargin
        let width = alertAppearance.appearance.window.width.adjustedValue - margin.left - margin.right
        let height = margin.top + margin.bottom
        if let mContent = messageLabel.text as NSString? {
            let height = LayoutUtil.getEstimateHeight(for: mContent, with: width, and: messageLabel.font)
            messageLabel.snp.makeConstraints({ (maker) in
                maker.leading.trailing.equalTo(parent).inset(margin)
                maker.top.equalTo(titleLabel.snp.bottom).offset(margin.top)
                maker.height.equalTo(height)
            })
            return height + margin.top + margin.bottom
        } else {
            messageLabel.snp.makeConstraints({ (maker) in
                maker.leading.trailing.equalTo(parent).inset(margin)
                maker.top.equalTo(titleLabel.snp.bottom).offset(margin.top)
                maker.height.equalTo(height)
            })
            return height
        }
    }
}

class CXAlertLayoutStrategy: CXAlertViewLayoutStrategy {
    func layout(actionButtons: [UIButton], to stackView: UIStackView, based detailLabel: UILabel, at: UIView, alertAppearance: CXAlertAppearance) -> CGFloat {
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        actionButtons.forEach {
            stackView.addArrangedSubview($0)
        }

        if actionButtons.count < 3 {
            stackView.axis = .horizontal
            stackView.snp.makeConstraints({ (maker) in
                maker.height.equalTo(alertAppearance.dimension.buttonHeight)
            })
            return alertAppearance.dimension.buttonHeight
        } else {
            stackView.axis = .vertical
            let height: CGFloat = CGFloat(actionButtons.count) * alertAppearance.dimension.buttonHeight
            stackView.snp.makeConstraints({ (maker) in
                maker.height.equalTo(height)
            })
            return height
        }
    }
}

class CXActionSheetStrategy: CXAlertViewLayoutStrategy {
    func layout(actionButtons: [UIButton], to stackView: UIStackView, based detailLabel: UILabel, at: UIView, alertAppearance: CXAlertAppearance) -> CGFloat {
        return 0
    }
}
