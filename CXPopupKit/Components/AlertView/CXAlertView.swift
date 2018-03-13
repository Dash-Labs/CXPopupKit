//
// Created by Cunqi Xiao on 8/10/17.
// Copyright (c) 2017 Cunqi Xiao. All rights reserved.
//

import UIKit
import SnapKit

public final class CXAlertView: UIView, CXPopupable {
    struct CXAlertContent {
        let title: String?
        let message: String?
        let cancelButtonTitile: String?
        let actionButtonTitles: [String]
    }

    public let titleLabel = UILabel()
    public let messageLabel = UILabel()
    public var actionButtons = [UIButton]()
    public var alertAppearance: CXAlertAppearance

    private let stackView = UIStackView()
    private let layoutStrategy: CXAlertViewLayoutStrategy
    private let content: CXAlertContent
    private let cancelButtonTag = -1

//    var titleLabelHeight: CGFloat = 0
//    var detailLabelHeight: CGFloat = 0
//    var actionButtonsHeight: CGFloat = 0
//
//    var estimateViewHeight: CGFloat {
//        return titleLabelHeight + detailLabelHeight + actionButtonsHeight
//    }



    public init(type: CXAlertType, title: String? = nil, message: String? = nil, cancel: String? = nil, actions: [String] = []) {
        self.layoutStrategy = type == .alert ? CXAlertLayoutStrategy() : CXActionSheetStrategy()
        self.alertAppearance = type.appearance
        self.content = CXAlertContent(title: title, message: message, cancelButtonTitile: cancel, actionButtonTitles: actions)
        super.init(frame: .zero)
    }

    func setup() {
        backgroundColor = alertAppearance.color.backgroundColor
        layer.cornerRadius = alertAppearance.dimension.cornerRadius
        layer.masksToBounds = true

        setupTitleLabel()
        setupMessageLabel()
        setupActionButton()
        setupStackViewBackground()
    }

    func setupTitleLabel() {
        titleLabel.text = content.title
        titleLabel.font = alertAppearance.font.title
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.backgroundColor = .clear
        addSubview(titleLabel)
    }

    func setupMessageLabel() {
        messageLabel.text = content.message
        messageLabel.font = alertAppearance.font.detail
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.lineBreakMode = .byWordWrapping
        addSubview(messageLabel)
    }

    func setupActionButton() {
        for actionTitle in content.actionButtonTitles {
            actionButtons.append(getActionButton(with: actionTitle))
        }

        if let cancelButtonTitle = content.cancelButtonTitile {
            let cancelButton = getActionButton(with: cancelButtonTitle)
            cancelButton.tag = cancelButtonTag
            actionButtons.append(cancelButton)
        }
    }

    func getActionButton(with buttonTitle: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(buttonTitle, for: .normal)
        button.titleLabel?.font = alertAppearance.font.action
        button.backgroundColor = alertAppearance.color.actionBackground
        button.setTitleColor(alertAppearance.color.actionTitle, for: .normal)
        button.addTarget(self, action: #selector(actionTriggered(button:)), for: .touchUpInside)
        return button
    }

    func setupStackViewBackground() {
        let stackViewBackgroundView = UIView()
        self.addSubview(stackViewBackgroundView)
        if alertAppearance.separator.isEnabled {
            stackViewBackgroundView.backgroundColor = alertAppearance.separator.color
            stackView.spacing = alertAppearance.separator.width
        }

        stackViewBackgroundView.addSubview(stackView)
        stackView.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalTo(stackViewBackgroundView)
            maker.top.equalTo(stackViewBackgroundView).offset(1)
        }

        stackViewBackgroundView.snp.makeConstraints { maker in
            maker.leading.trailing.bottom.equalTo(self)
            maker.top.equalTo(self.messageLabel.snp.bottom).offset(alertAppearance.dimension.messageMargin.bottom)
        }
    }

    func setupLayout() {
        var height: CGFloat = 0
        height += layoutStrategy.layout(titleLabel: titleLabel, at: self, alertAppearance: alertAppearance)
        height += layoutStrategy.layout(messageLabel: messageLabel, based: titleLabel, at: self, alertAppearance: alertAppearance)
        height += layoutStrategy.layout(actionButtons: actionButtons, to: stackView, based: messageLabel, at: self, alertAppearance: alertAppearance)
        alertAppearance.appearance.window.height = .fixValue(size: height)
    }

    @objc func actionTriggered(button: UIButton) {
        let result = button.title(for: .normal)
        if button.tag == cancelButtonTag {
            self.popup?.completeWithNegative(result: result)
        } else {
            self.popup?.completeWithPositive(result: result)
        }
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func createPopup() -> CXPopup {
        setup()
        setupLayout()
        return CXPopup(with: self, appearance: alertAppearance.appearance)
    }

    public func show(at presenter: UIViewController?) {
        createPopup().show(at: presenter)
    }
}
