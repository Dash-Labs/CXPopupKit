//
//  CXPopup.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 12/18/17.
//  Copyright © 2017 Cunqi Xiao. All rights reserved.
//

import UIKit
import SnapKit

public typealias CXPopupHandler = (Any?) -> Void
public typealias CXPopupLifeCycleAction = () -> Void

public final class Popupable<Base> {
    public let base: Base

    init(base: Base) {
        self.base = base
    }
    
    deinit {
        print("RELEASED")
    }
    
    var window: PopupWindow? {
        guard let mContent = base as? UIView else {
            return nil
        }
        
        var responder: UIResponder? = mContent
        while responder != nil {
            responder = responder?.next
            
            if let window = responder as? PopupWindow {
                return window
            }
        }
        return nil
    }

    public func completeWithPositiveAction(result: Any?) {
        DispatchQueue.main.async { [weak self] in
            self?.window?.positiveAction?(result)
            self?.window?.dismiss(animated: true)
        }
    }

    public func completeWithNegativeAction(result: Any?) {
        DispatchQueue.main.async {
            self.window?.negativeAction?(result)
            self.window?.dismiss(animated: true)
        }
    }

    public func dismiss() {
        DispatchQueue.main.async {
            self.window?.dismiss(animated: true)
        }
    }
    
    @discardableResult public func show(at presenter: UIViewController?, appearance: CXAppearance = CXAppearance(), positive: CXPopupHandler? = nil, negative: CXPopupHandler? = nil, viewDidLoad: CXPopupLifeCycleAction? = nil, viewDidDisappear: CXPopupLifeCycleAction? = nil) -> PopupWindow {
        guard let mContent = base as? UIView else {
            return PopupWindow()
        }
        
        let popupWindow = PopupWindow()
        let presentationController = CXPresentationController(presentedViewController: popupWindow, presenting: presenter)
        popupWindow.transitioningDelegate = presentationController
        popupWindow.content = mContent
        popupWindow.positiveAction = positive
        popupWindow.negativeAction = negative
        popupWindow.viewDidLoadAction = viewDidLoad
        popupWindow.viewDidDisappearAction = viewDidDisappear

        popupWindow.appearance = appearance
        presentationController.appearance = appearance
        
        presenter?.present(popupWindow, animated: true, completion: nil)
        return popupWindow
    }
}

public protocol PopupableCompatible {
    associatedtype CompatibleType
    var cx: Popupable<CompatibleType> { get }
}

public extension PopupableCompatible {
    public var cx: Popupable<Self> {
        return Popupable(base: self)
    }
}

extension UIView: PopupableCompatible {}
