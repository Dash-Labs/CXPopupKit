//
//  CXBouncePopupAnimation.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 12/28/17.
//  Copyright © 2017 Cunqi Xiao. All rights reserved.
//

import Foundation

final class CXBouncePopupAnimation: CXAbstractPopupAnimation {
    override func transitionIn() {
        toViewInitialFrame = PositionUtil.inferInitialFrame(from: toViewFinalFrame, direction: direction, based: containerView.bounds.size)
        toView?.frame = toViewInitialFrame
        UIView.animate(withDuration: duration,
                delay: 0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0,
                options: .curveEaseOut,
                animations: { [unowned self] in
                    self.toView?.frame = self.toViewFinalFrame
                }) { completed in
            self.context.completeTransition(completed)
        }
    }

    override func transitionOut() {
        fromViewFinalFrame = PositionUtil.inferFinalFrame(from: fromView!.frame, direction: direction, based: containerView.bounds.size)

        UIView.animate(withDuration: duration,
                delay: 0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0,
                options: .curveEaseOut,
                animations: { [unowned self] in
                    self.fromView?.frame = self.fromViewFinalFrame
                }) { completed in
            self.context.completeTransition(completed)
        }
    }
}
