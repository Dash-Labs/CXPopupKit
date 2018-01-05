//
// Created by Cunqi Xiao on 12/20/17.
// Copyright (c) 2017 Cunqi Xiao. All rights reserved.
//

import UIKit

public final class PopupWindow: UIViewController {

    public override var shouldAutorotate: Bool {
        return appearance.orientation.isAutoRotationEnabled
    }

    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return appearance.orientation.supportedInterfaceOrientations
    }

    public override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return appearance.orientation.preferredInterfaceOrientationForPresentation
    }

    var negativeAction: CXPopupHandler?
    var positiveAction: CXPopupHandler?
    var appearance: CXAppearance!
    var content: UIView!

    // Life cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }

    deinit {
        print("POPUP DEINIT")
    }

    private func setupLayout() {
        LayoutUtil.fill(view: content, at: view)
    }

    @objc private func dismissPopup() {
        self.dismiss(animated: true, completion: nil)
    }
}
