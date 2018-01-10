//
// Created by Cunqi Xiao on 8/10/17.
// Copyright (c) 2017 Cunqi Xiao. All rights reserved.
//

import UIKit
import SnapKit

public final class CXAlertView: UIView {
    public var alertAppearance: CXAlertAppearance

    let titleLabel = UILabel()
    let detailLabel = UILabel()
    let stackView = UIStackView()
    var actionButtons = [UIButton]()

    var titleLabelHeight: CGFloat = 0
    var detailLabelHeight: CGFloat = 0
    var actionButtonsHeight: CGFloat = 0

    var estimateViewHeight: CGFloat {
        return titleLabelHeight + detailLabelHeight + actionButtonsHeight
    }

    private let cancelButtonTag = -1
    private let title: String?
    private let detail: String?
    private let cancel: String?
    private let actions: [String]

    public init(type: CXAlertType, title: String? = nil, detail: String? = nil, cancel: String? = nil, actions: [String] = []) {
        self.alertAppearance = type.appearance
        self.title = title
        self.detail = detail
        self.cancel = cancel
        self.actions = actions
        super.init(frame: .zero)
    }

    public func show(at presenter: UIViewController?, positive: CXPopupHandler? = nil, negative: CXPopupHandler? = nil) {
        setupContainer()
        setupLayout()

        alertAppearance.appearance.window.allowTouchOutsideToDismiss = !alertAppearance.isModal
        alertAppearance.appearance.window.height = .fixValue(size: estimateViewHeight)
        self.cx.show(at: presenter, appearance: alertAppearance.appearance, positive: positive, negative: negative)
    }

    func setupContainer() {
        self.backgroundColor = alertAppearance.color.backgroundColor
        self.layer.cornerRadius = alertAppearance.dimension.cornerRadius
        self.layer.masksToBounds = true

        setupTitleLabel(with: title)
        setupDetailLabel(with: detail)
        setupActionButtons(with: actions, cancel: cancel)
    }

    func setupStackView() {
        let stackViewBackgroundView = UIView()
        self.addSubview(stackViewBackgroundView)
        LayoutUtil.fill(view: stackView, at: stackViewBackgroundView)
        drawSeparator(at: stackViewBackgroundView)
        if alertAppearance.separator.isEnabled {
            stackViewBackgroundView.backgroundColor = alertAppearance.separator.color
            stackView.spacing = alertAppearance.separator.width
        }
        stackViewBackgroundView.snp.makeConstraints { maker in
            maker.leading.trailing.bottom.equalTo(self)
            maker.top.equalTo(self.detailLabel.snp.bottom).offset(alertAppearance.dimension.detailMargin.bottom)
        }
    }

    func setupLayout() {
        layoutActionButtons()
        updateDetailLabelHeight()
        updateTitleLabelHeight()

    }

    private func setupTitleLabel(with title: String?) {
        titleLabel.text = title
        titleLabel.font = alertAppearance.font.title
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.backgroundColor = .clear
        addSubview(titleLabel)
    }

    private func updateTitleLabelHeight() {
        let margin = alertAppearance.dimension.titleMargin
        if case let .fixValue(size) = alertAppearance.appearance.window.width, let mText = titleLabel.text as NSString? {
            let targetWidth = size - margin.left - margin.right
            let targetHeight = LayoutUtil.getEstimateHeight(for: mText, with: targetWidth, and: alertAppearance.font.title)

            titleLabel.snp.makeConstraints { maker in
                maker.leading.trailing.equalTo(self).inset(margin)
                maker.height.equalTo(targetHeight)
            }
            titleLabelHeight = targetHeight + margin.top + margin.bottom
        } else {
            titleLabelHeight = 0
            titleLabel.snp.makeConstraints { maker in
                maker.leading.trailing.top.equalTo(self).inset(margin)
                maker.height.equalTo(titleLabelHeight)
            }
        }
    }

    private func setupDetailLabel(with detail: String?) {
        detailLabel.text = detail
        detailLabel.font = alertAppearance.font.detail
        detailLabel.textAlignment = .center
        detailLabel.numberOfLines = 0
        detailLabel.lineBreakMode = .byWordWrapping
        addSubview(detailLabel)
    }

    private func updateDetailLabelHeight() {
        let margin = alertAppearance.dimension.detailMargin
        if case let .fixValue(size) = alertAppearance.appearance.window.width, let mText = detailLabel.text as NSString? {
            let targetWidth = size - margin.left - margin.right
            let targetHeight = LayoutUtil.getEstimateHeight(for: mText, with: targetWidth, and: alertAppearance.font.detail)

            detailLabel.snp.makeConstraints { maker in
                maker.leading.trailing.equalTo(self).inset(margin)
                maker.top.equalTo(titleLabel.snp.bottom).offset(margin.top)
                maker.height.equalTo(targetHeight)
            }
            detailLabelHeight = targetHeight + margin.top + margin.bottom
        } else {
            detailLabelHeight = margin.top + margin.bottom
            detailLabel.snp.makeConstraints { maker in
                maker.leading.trailing.equalTo(self).inset(margin)
                maker.top.equalTo(titleLabel.snp.bottom).offset(margin.top)
                maker.height.equalTo(detailLabelHeight)
            }
        }
    }

    private func setupActionButtons(with actions: [String], cancel: String?) {
        for (index, action) in actions.enumerated() {
            createActionButton(action: action, tag: index)
        }

        if let mCancel = cancel {
            createActionButton(action: mCancel, tag: cancelButtonTag)
        }
    }

    private func createActionButton(action: String, tag: Int) {
        let button = UIButton(type: .system)
        button.tag = tag
        setup(button: button, with: action, and: tag)
    }

    private func setup(button: UIButton, with action: String, and tag: Int) {
        let buttonFont = tag == cancelButtonTag ? alertAppearance.font.cancel : alertAppearance.font.action
        let buttonTitleColor = tag == cancelButtonTag ? alertAppearance.color.cancelTitle : alertAppearance.color.actionTitle
        let buttonBackgroundColor = tag == cancelButtonTag ? alertAppearance.color.cancelBackground : alertAppearance.color.actionBackground

        button.setTitle(action, for: .normal)
        button.titleLabel?.font = buttonFont
        button.backgroundColor = buttonBackgroundColor
        button.setTitleColor(buttonTitleColor, for: .normal)

        actionButtons.append(button)
        button.addTarget(self, action: #selector(actionTriggered(button:)), for: .touchUpInside)
    }

    @objc func actionTriggered(button: UIButton) {
        if button.tag == cancelButtonTag {
            self.cx.completeWithNegativeAction(result: button.title(for: .normal))
        } else {
            self.cx.completeWithPositiveAction(result: button.title(for: .normal))
        }
    }

    private func layoutActionButtons() {
        setupStackView()
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        if alertAppearance.alertType == .alert && actionButtons.count == 2 {
            if let left = actionButtons.first, let right = actionButtons.last {
                stackView.axis = .horizontal
                stackView.addArrangedSubview(left)
                stackView.addArrangedSubview(right)
            }
        } else {
            for button in actionButtons {
                stackView.axis = .vertical
                stackView.addArrangedSubview(button)
            }
        }
        updateActionButtonsHeight()
    }

    private func updateActionButtonsHeight() {
        if alertAppearance.alertType == .alert && actionButtons.count == 2 {
            actionButtonsHeight = alertAppearance.dimension.buttonHeight
        } else {
            actionButtonsHeight = alertAppearance.dimension.buttonHeight * CGFloat(actionButtons.count)
        }
        stackView.snp.makeConstraints { maker in
            maker.height.equalTo(actionButtonsHeight)
        }
    }

    private func drawSeparator(at parent: UIView) {
        if alertAppearance.separator.isEnabled {
            let separator = UIView(frame: .zero)
            parent.addSubview(separator)
            separator.backgroundColor = alertAppearance.separator.color
            separator.snp.makeConstraints { maker in
                maker.leading.trailing.top.equalTo(self.stackView)
                maker.height.equalTo(alertAppearance.separator.width)
            }
        }
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
