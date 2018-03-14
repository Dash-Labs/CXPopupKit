//
//  CXDatePicker.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 3/14/18.
//  Copyright © 2018 Cunqi Xiao. All rights reserved.
//

import UIKit
import SnapKit

public class CXDatePicker: UIView, CXPopupable {
    public let picker = UIDatePicker()
    public let navigationBar = UINavigationBar()
    public var title: String?
    public var cancelButtonText: String?
    public var doneButtonText: String?

    var appearance: CXAppearance = {
        var appearance = CXAppearance()
        appearance.window.width = .equalToParent
        appearance.window.height = .fixValue(size: 320)
        appearance.window.allowTouchOutsideToDismiss = false
        appearance.window.enableInsideSafeArea = true
        appearance.window.position = .bottom
        appearance.animation.duration = CXAnimation.Duration(0.35)
        appearance.animation.transition = CXAnimation.Transition(in: .up, out: .down)
        appearance.animation.style = .plain
        return appearance
    }()
    private var selectedDate: Date = Date()

    public func createPopup() -> CXPopup {
        setup()
        appearance.window.backgroundColor = picker.backgroundColor ?? .white
        return CXPopup(with: self, appearance: self.appearance)
    }

    public init(startDate: Date?, mode: UIDatePickerMode, title: String?, cancelButtonText: String?, doneButtonText: String?) {
        super.init(frame: .zero)
        self.selectedDate = startDate ?? Date()
        self.title = title
        self.cancelButtonText = cancelButtonText
        self.doneButtonText = doneButtonText
        self.picker.datePickerMode = mode
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        picker.setDate(selectedDate, animated: true)
        setupNavigationBar()
        setupLayout()
    }

    private func setupLayout() {
        self.addSubview(navigationBar)
        navigationBar.snp.makeConstraints { (maker) in
            maker.leading.top.trailing.equalTo(self)
            maker.height.equalTo(44)
        }

        self.addSubview(picker)
        picker.snp.makeConstraints { (maker) in
            maker.leading.trailing.bottom.equalTo(self)
            maker.top.equalTo(navigationBar.snp.bottom)
        }
    }

    private func setupNavigationBar() {
        let navigationItem = UINavigationItem(title: title ?? "")
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: cancelButtonText, style: .plain, target: self, action: #selector(didTapCancelButton))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: doneButtonText, style: .done, target: self, action: #selector(didTapDoneButton))
        navigationBar.pushItem(navigationItem, animated: true)
    }

    @objc private func didTapCancelButton(_ sender: Any) {
        popup?.completeWithNegative(result: nil)
    }

    @objc private func didTapDoneButton(_ sender: Any) {
        popup?.completeWithPositive(result: picker.date)
    }
}
