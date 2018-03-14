//
//  DemoListViewController.swift
//  CXPopupKitDemo
//
//  Created by Cunqi Xiao on 3/13/18.
//  Copyright © 2018 Cunqi Xiao. All rights reserved.
//

import UIKit
import CXPopupKit

class DemoListViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!

    private let items: [DemoItem] = [.basic, .roundedCorner, .slideMenu, .slideMenuWithSafeArea, .actionSheet, .basicSampleWithSafeAreaInside, .basicSampleWithoutSafeAreaButPadding, .alertView]
    private let cellIdentifier = "DemoItem"

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Demo List"
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension DemoListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let item = items[indexPath.row]
        cell.textLabel?.text = item.title
        return cell
    }
}

extension DemoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        switch item {
        case .basic:
            showBasicPopup()
        case .roundedCorner:
            showRoundedCornerPopup()
        case .slideMenu:
            showSlideMenuPopup()
        case .slideMenuWithSafeArea:
            showSlideMenuWithSafeAreaPopup()
        case .actionSheet:
            showActionSheetPopup()
        case .basicSampleWithSafeAreaInside:
            showBasicSampleWithSafeAreaInsidePopup()
        case .basicSampleWithoutSafeAreaButPadding:
            showBasicSampleWithoutSafeAreaButPadding()
        case .alertView:
            showAlertViewPopup()
        }
    }

    private func showBasicPopup() {
        let basicSample = BasicSample()
        basicSample.backgroundColor = .white
        basicSample.appearance.window.width = .fixValue(size: 300)
        basicSample.appearance.window.height = .partOfParent(percent: 0.35)
        basicSample.appearance.window.position = .center
        basicSample.appearance.animation.style = .bounceZoom
        let popup = basicSample.createPopup()
        DispatchQueue.main.async {
            popup.show(at: self)
        }
    }

    private func showRoundedCornerPopup() {
        let basicSample = BasicSample()
        basicSample.backgroundColor = .white
        basicSample.layer.cornerRadius = 9.0
        basicSample.layer.masksToBounds = true
        basicSample.appearance.window.width = .fixValue(size: 300)
        basicSample.appearance.window.height = .partOfParent(percent: 0.35)
        basicSample.appearance.window.position = .center
        basicSample.appearance.animation.style = .bounceZoom
        basicSample.appearance.orientation.isAutoRotationEnabled = true
        let popup = basicSample.createPopup()
        DispatchQueue.main.async {
            popup.show(at: self)
        }
    }

    private func showSlideMenuPopup() {
        let menuSample = MenuSample()
        menuSample.backgroundColor = .white
        menuSample.appearance.window.isSafeAreaEnabled = false
        let popup = menuSample.createPopup()
        DispatchQueue.main.async {
            popup.show(at: self)
        }
    }

    private func showSlideMenuWithSafeAreaPopup() {
        let menuSample = MenuSample()
        menuSample.backgroundColor = .white
        menuSample.appearance.window.backgroundColor = .clear
        menuSample.appearance.window.isSafeAreaEnabled = true
        let popup = menuSample.createPopup()
        DispatchQueue.main.async {
            popup.show(at: self)
        }
    }

    private func showActionSheetPopup() {
        let actionSheet = CXAlertView(type: .actionSheet, title: nil, message: "Pick a photo from library", cancel: "cancel", actions: ["OK"])
        DispatchQueue.main.async {
            actionSheet.show(at: self)
        }
    }

    private func showAlertViewPopup() {
        let actionSheet = CXAlertView(type: .alert, title: nil, message: "Pick a photo from library", cancel: "cancel", actions: ["OK"])
        DispatchQueue.main.async {
            actionSheet.show(at: self)
        }
    }

    private func showBasicSampleWithSafeAreaInsidePopup() {
        let basicSample = BasicSample()
        basicSample.backgroundColor = .white
        basicSample.appearance.window.width = .equalToParent
        basicSample.appearance.window.height = .partOfParent(percent: 0.35)
        basicSample.appearance.window.position = .bottom
        basicSample.appearance.window.backgroundColor = .white
        basicSample.appearance.animation.style = .fade
        basicSample.appearance.window.isSafeAreaEnabled = true
        basicSample.appearance.window.enableInsideSafeArea = true
        let popup = basicSample.createPopup()
        DispatchQueue.main.async {
            popup.show(at: self)
        }
    }

    private func showBasicSampleWithoutSafeAreaButPadding() {
        let basicSample = BasicSample()
        basicSample.layer.cornerRadius = 32.0
        basicSample.layer.masksToBounds = true
        basicSample.backgroundColor = .white
        basicSample.appearance.window.width = .partOfParent(percent: 0.95)
        basicSample.appearance.window.height = .partOfParent(percent: 0.35)
        basicSample.appearance.window.position = .bottom
        basicSample.appearance.animation.style = .fade
        basicSample.appearance.window.isSafeAreaEnabled = true
        basicSample.appearance.window.margin = UIEdgeInsets(top: 0, left: 8, bottom: 8, right: 8)
        let popup = basicSample.createPopup()
        DispatchQueue.main.async {
            popup.show(at: self)
        }
    }
}

enum DemoItem {
    case basic
    case roundedCorner
    case slideMenu
    case slideMenuWithSafeArea
    case actionSheet
    case basicSampleWithSafeAreaInside
    case basicSampleWithoutSafeAreaButPadding
    case alertView

    var title: String {
        switch self {
        case .basic:
            return "Basic + (Plain Animation)"
        case .roundedCorner:
            return "Rounded corner + (Bounce zoom animation)"
        case .slideMenu:
            return "Slide menu (disable safe area)"
        case .slideMenuWithSafeArea:
            return "Slide menu (enable safe area)"
        case .actionSheet:
            return "Action sheet"
        case .basicSampleWithSafeAreaInside:
            return "Basic + (Safe area inside)"
        case .basicSampleWithoutSafeAreaButPadding:
            return "Basic + (Padding, no safe area)"
        case .alertView:
            return "Alert View"
        }
    }
}
