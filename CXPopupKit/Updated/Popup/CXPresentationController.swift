//
//  CXPresentationController.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 12/25/17.
//  Copyright © 2017 Cunqi Xiao. All rights reserved.
//

import UIKit

final class CXPresentationController: UIPresentationController, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    var appearance = CXAppearance()

    private var presentationWrapperView: UIView?
    private var backgroundView: UIView?

    override var frameOfPresentedViewInContainerView: CGRect {
        return LayoutUtil.presentedViewSize(containerView!, appearance.window, appearance.window.isSafeAreaEnabled)
    }

    override var presentedView: UIView? {
        return presentationWrapperView
    }

    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        presentedViewController.modalPresentationStyle = .custom
    }

    override func presentationTransitionWillBegin() {
        setupPresentationWrapperView()
        updatePresentedViewControllerView()
        setupBackgroundView()
    }

    override func presentationTransitionDidEnd(_ completed: Bool) {
        if !completed {
            self.presentationWrapperView = nil
            self.backgroundView = nil
        }
    }

    override func dismissalTransitionWillBegin() {
        let coordinator = self.presentingViewController.transitionCoordinator
        coordinator?.animate(alongsideTransition: { [weak self] context in
            self?.backgroundView?.alpha = 0
        }, completion: nil)
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if !completed {
            self.presentationWrapperView = nil
            self.backgroundView = nil
        }
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        guard let fromViewController = transitionContext?.viewController(forKey: .from) else {
            return appearance.animation.duration.out
        }
        let isPresenting = fromViewController == self.presentingViewController
        return isPresenting ? appearance.animation.duration.in : appearance.animation.duration.out
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let isPresenting = transitionContext.viewController(forKey: .from) == self.presentingViewController
        let animation = appearance.animation.getAnimation(transitionContext, isPresenting)
        animation.execute()
    }

    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        self.backgroundView?.frame = self.containerView!.bounds
        updatePresentationWrapperViewFrame()
    }

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return self
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

    private func updatePresentedViewControllerView() {
        let presentedViewControllerView = super.presentedView!
        let frame = CGRect(origin: .zero, size: frameOfPresentedViewInContainerView.size)
        presentedViewControllerView.frame = frame
        presentedViewControllerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        presentationWrapperView?.addSubview(presentedViewControllerView)
    }

    private func setupPresentationWrapperView() {
        presentationWrapperView = UIView()
        presentationWrapperView?.backgroundColor = appearance.window.backgroundColor
        updatePresentationWrapperViewFrame()

        if appearance.shadow.isEnabled {
            presentationWrapperView?.layer.shadowColor = appearance.shadow.color.cgColor
            presentationWrapperView?.layer.shadowOffset = appearance.shadow.offset
            presentationWrapperView?.layer.shadowRadius = appearance.shadow.radius
            presentationWrapperView?.layer.shadowOpacity = appearance.shadow.opacity
        }
    }

    private func updatePresentationWrapperViewFrame() {
        presentationWrapperView?.frame = frameOfPresentedViewInContainerView
        if appearance.window.enableInsideSafeArea {
            presentationWrapperView?.frame = LayoutUtil.updateFrameForInsideSafeArea(frame: presentationWrapperView?.frame, at: containerView!, position: appearance.window.position)
        }
    }

    private func setupBackgroundView() {
        backgroundView = UIView(frame: containerView!.bounds)
        backgroundView?.backgroundColor = appearance.window.maskBackgroundColor
        backgroundView?.alpha = appearance.window.maskBackgroundAlpha
        backgroundView?.isOpaque = false

        if appearance.window.allowTouchOutsideToDismiss {
            backgroundView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backgroundViewTapped)))
        }
        containerView?.addSubview(backgroundView!)

        let coordinator = self.presentingViewController.transitionCoordinator
        backgroundView?.alpha = 0
        coordinator?.animate(alongsideTransition: { [unowned self] context in
            self.backgroundView?.alpha = self.appearance.window.maskBackgroundAlpha
        }, completion: nil)
    }

    @objc private func backgroundViewTapped(gesture: UITapGestureRecognizer) {
        presentingViewController.dismiss(animated: true, completion: nil)
    }
}
