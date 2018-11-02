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
        let alertView = CXAlertView(type: .alert, title: "Hello", detail: "Apple introduced storyboard references in iOS 9 and macOS 10.11 with the goal of making storyboards less daunting and easier to manage. Storyboard references allow you to break a storyboard up into multiple, smaller storyboards. A storyboard reference ties multiple storyboards together, creating one, ...", cancel: "OK", actions: ["YES"])
        alertView.alertAppearance.color.backgroundColor = .white
        alertView.show(at: self)
    }
}
