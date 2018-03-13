//
//  CXPopupWindow.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 3/8/18.
//  Copyright © 2018 Cunqi Xiao. All rights reserved.
//

import UIKit

class CXPopupWindow: UIViewController {
    override var shouldAutorotate: Bool {
        return appearance.orientation.isAutoRotationEnabled
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return appearance.orientation.supportedInterfaceOrientations
    }

     override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return appearance.orientation.preferredInterfaceOrientationForPresentation
    }

    var holder: CXPopup?
    var appearance = CXAppearance()
    var content: CXPopupable?

    var negativeAction: CXPopupHandler?
    var positiveAction: CXPopupHandler?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        content?.popupWindowDidLoad()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        holder = nil
        content?.popupWindowDidDisappear()
    }

    private func setup() {
        let window = appearance.window
        view.backgroundColor = window.backgroundColor

        let strategy = getLayoutStrategy()
        strategy.install((content as? UIView) ?? UIView(), into: view, basedOn: appearance)
    }

    deinit {
         print("CXPopupWindow deinit")
    }

    private func getLayoutStrategy() -> CXPopupLayoutStrategy {
        let w = appearance.window

        if !w.isSafeAreaEnabled {
            return LayoutWithoutSafeAreaStrategy()
        }else {
            return LayoutWithOutsideSafeAreaStrategy()
        }
    }
}
