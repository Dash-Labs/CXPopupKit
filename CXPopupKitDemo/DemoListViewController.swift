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

    private let items: [DemoItem] = [.basic, .roundedCorner, .slideMenu, .slideMenuWithSafeArea]
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
        }
    }

    private func showBasicPopup() {
        let basicSample = BasicSample()
        basicSample.backgroundColor = .white
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
        basicSample.appearance.animation.style = .bounceZoom
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
}

enum DemoItem {
    case basic
    case roundedCorner
    case slideMenu
    case slideMenuWithSafeArea

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
        }
    }
}
