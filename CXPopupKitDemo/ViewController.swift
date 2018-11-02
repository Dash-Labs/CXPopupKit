//
//  ViewController.swift
//  CXPopupKitDemo
//
//  Created by Cunqi Xiao on 12/20/17.
//  Copyright © 2017 Cunqi Xiao. All rights reserved.
//

import UIKit
import CXPopupKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didTapButton(_ sender: Any) {
//        let popup = UIView()
//        popup.backgroundColor = .red
//        popup.layer.masksToBounds = true
//
//        var appearance = CXAppearance()
//        appearance.window.width = .equalToParent
//        appearance.window.height = .partOfParent(percent: 0.5)
//        appearance.window.position = .top
//        appearance.window.isSafeAreaEnabled = true
//        appearance.window.shouldFillOutSafeArea = true
//        appearance.window.backgroundColor = .white
//        appearance.window.allowTouchOutsideToDismiss = true
//        appearance.orientation.isAutoRotationEnabled = true
//        appearance.animation.duration = CXAnimation.Duration(in: 0.35, out: 0.35)
//        appearance.animation.style = .bounceZoom
//        appearance.animation.transition = CXAnimation.Transition(in: .up, out: .down)
//
//        popup.cx.show(at: self, appearance: appearance, viewDidLoad: {
//            popup.backgroundColor = .black
//        })
        let alertView = CXAlertView(type: .alert, title: "Hello", detail: "Apple introduced storyboard references in iOS 9 and macOS 10.11 with the goal of making storyboards less daunting and easier to manage. Storyboard references allow you to break a storyboard up into multiple, smaller storyboards. A storyboard reference ties multiple storyboards together, creating one, ...", cancel: "OK", actions: ["YES"])
        alertView.alertAppearance.color.backgroundColor = .white
        alertView.show(at: self)
    }
}
