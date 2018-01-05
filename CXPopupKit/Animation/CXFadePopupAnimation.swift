//
//  CXFadePopupAnimation.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 12/26/17.
//  Copyright © 2017 Cunqi Xiao. All rights reserved.
//

import Foundation

final class CXFadePopupAnimation: CXAbstractPopupAnimation {
    override func transitionIn() {
        toViewInitialFrame = PositionUtil.inferInitialFrame(from: toViewFinalFrame, direction: direction, based: containerView.bounds.size)
        let toViewAlpha = toView?.alpha ?? 1
        toView?.frame = toViewInitialFrame
        toView?.alpha = 0
        UIView.animate(withDuration: duration, animations: { [unowned self] in
            self.toView?.frame = self.toViewFinalFrame
            self.toView?.alpha = toViewAlpha
        }) { completed in
            self.context.completeTransition(completed)
        }
    }
    
    override func transitionOut() {
        fromViewFinalFrame = PositionUtil.inferFinalFrame(from: fromView!.frame, direction: direction, based: containerView.bounds.size)
        UIView.animate(withDuration: duration, animations: { [unowned self] in
            self.fromView?.frame = self.fromViewFinalFrame
            self.fromView?.alpha = 0
        }) { completed in
            self.context.completeTransition(completed)
        }
    }
}

