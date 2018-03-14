//
//  CXPicker.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 3/14/18.
//  Copyright © 2018 Cunqi Xiao. All rights reserved.
//

import UIKit
import SnapKit

public protocol CXPickerExpressible {
    func getCXPickerOptionName() -> String
}

extension String: CXPickerExpressible {
    public func getCXPickerOptionName() -> String {
        return self
    }
}

public class CXPicker: UIView, CXPopupable {
    public let picker = UIPickerView()
    public let navigationBar = UINavigationBar()
    public var options = [[CXPickerExpressible]]()
    public var rowHeight: CGFloat = 44
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

    private var selectedOptions = [CXPickerExpressible]()

    public func createPopup() -> CXPopup {
        setup()
        appearance.window.backgroundColor = picker.backgroundColor!
        return CXPopup(with: self, appearance: self.appearance)
    }

    public init(with singleColumOptions: [CXPickerExpressible], title: String?, cancelButtonText: String?, doneButtonText: String?) {
        super.init(frame: .zero)
        self.options = [singleColumOptions]
        self.title = title
        self.cancelButtonText = cancelButtonText
        self.doneButtonText = doneButtonText
    }

    public init(with options: [[CXPickerExpressible]], title: String?, cancelButtonText: String?, doneButtonText: String?) {
        super.init(frame: .zero)
        self.options = options
        self.title = title
        self.cancelButtonText = cancelButtonText
        self.doneButtonText = doneButtonText
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        setupPicker()
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

    private func setupPicker() {
        self.picker.dataSource = self
        self.picker.delegate = self
        self.picker.backgroundColor = .white
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
        for component in 0 ..< options.count {
            let row = picker.selectedRow(inComponent: component)
            selectedOptions.append(options[component][row])
        }

        if selectedOptions.count < 2 {
            popup?.completeWithPositive(result: selectedOptions.first)
        } else {
            popup?.completeWithPositive(result: selectedOptions)
        }
    }
}

extension CXPicker: UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return options.count
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options[component].count
    }
}

extension CXPicker: UIPickerViewDelegate {
    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return rowHeight
    }

    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let option = options[component][row]
        return option.getCXPickerOptionName()
    }
}
