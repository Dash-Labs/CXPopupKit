//
//  CXPresentationController.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 12/25/17.
//  Copyright © 2017 Cunqi Xiao. All rights reserved.
//

import UIKit

final class CXPresentationController: UIPresentationController, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    var appearance: CXAppearance!
    var presentationWrapperView: UIView!
    var backgroundView: UIView!

    override var frameOfPresentedViewInContainerView: CGRect {
        let frame = LayoutUtil.presentedViewSize(in: containerView!,
                                                 width: appearance.window.width,
                                                 height: appearance.window.height,
                                                 attached: appearance.window.position,
                                                 isFollowingSafeAreaGuide: appearance.window.isSafeAreaEnabled,
                                                 shouldFillOutSafeArea: appearance.window.shouldFillOutSafeArea)
        return frame
    }

    public override var presentedView: UIView? {
        return presentationWrapperView
    }

    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        presentedViewController.modalPresentationStyle = .custom
    }

    public override func presentationTransitionWillBegin() {
        self.presentationWrapperView = setupPresentationWrapperView()

        let presentedViewControllerView = super.presentedView!
        presentedViewControllerView.frame = presentationWrapperView!.bounds
        presentedViewControllerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        presentationWrapperView.addSubview(presentedViewControllerView)

        backgroundView = setupBackgroundView()
        let coordinator = self.presentingViewController.transitionCoordinator
        backgroundView.alpha = 0
        coordinator?.animate(alongsideTransition: { [unowned self] context in
            self.backgroundView.alpha = self.appearance.window.maskBackgroundAlpha
        }, completion: nil)
    }

    private func setupPresentationWrapperView() -> UIView {
        let presentationWrapperView = UIView(frame: self.frameOfPresentedViewInContainerView)
        if appearance.shadow.isEnabled {
            presentationWrapperView.layer.shadowColor = appearance.shadow.color.cgColor
            presentationWrapperView.layer.shadowOffset = appearance.shadow.offset
            presentationWrapperView.layer.shadowRadius = appearance.shadow.radius
            presentationWrapperView.layer.shadowOpacity = appearance.shadow.opacity
        }
        return presentationWrapperView
    }

    private func setupBackgroundView() -> UIView {
        let backgroundView = UIView(frame: self.containerView!.bounds)
        backgroundView.backgroundColor = appearance.window.maskBackgroundColor
        backgroundView.alpha = appearance.window.maskBackgroundAlpha
        backgroundView.isOpaque = false

        if appearance.window.allowTouchOutsideToDismiss {
            backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backgroundViewTapped)))
        }

        self.containerView?.addSubview(backgroundView)
        return backgroundView
    }

    @objc private func backgroundViewTapped(gesture: UITapGestureRecognizer) {
        self.presentingViewController.dismiss(animated: true, completion: nil)
    }

    public override func presentationTransitionDidEnd(_ completed: Bool) {
        if !completed {
            self.presentationWrapperView = nil
            self.backgroundView = nil
        }
    }

    public override func dismissalTransitionWillBegin() {
        let coordinator = self.presentingViewController.transitionCoordinator
        coordinator?.animate(alongsideTransition: { [weak self] context in
            self?.backgroundView.alpha = 0
        }, completion: nil)
    }

    public override func dismissalTransitionDidEnd(_ completed: Bool) {
        if !completed {
            self.presentationWrapperView = nil
            self.backgroundView = nil
        }
    }

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        guard let fromViewController = transitionContext?.viewController(forKey: .from) else {
            return appearance.animation.duration.out
        }
        let isPresenting = fromViewController == self.presentingViewController
        return isPresenting ? appearance.animation.duration.in : appearance.animation.duration.out
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let isPresenting = transitionContext.viewController(forKey: .from) == self.presentingViewController
        let animation = appearance.animation.getAnimation(transitionContext, isPresenting)
        animation.execute()
    }

    public override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        self.backgroundView.frame = self.containerView!.bounds
        self.presentationWrapperView.frame = self.frameOfPresentedViewInContainerView
    }

    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return self
    }

    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}
