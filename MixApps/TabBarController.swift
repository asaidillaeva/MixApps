//
//  Tabbar.swift
//  MixApps
//
//  Created by Aliia Saidillaeva  on 25/6/22.
//

import UIKit

fileprivate enum TabbarItems: CaseIterable {
    case todo
    case stopwatch
    
    var tabbarItem: UITabBarItem {
        switch self {
        case .todo:
            return .init(
                title: "Todo",
                image: .init(systemName: "pencil.circle"),
                selectedImage: .init(systemName: "pencil.circle.fill")
            )
        case .stopwatch:
            return .init(
                title: "StopWatch",
                image: .init(systemName: "stopwatch"),
                selectedImage: .init(systemName: "stopwatch.fill")
            )
        }
    }
    
    var navigationController: UINavigationController {
        let viewController: UINavigationController!
        switch self {
        case .todo:
            viewController = .init(rootViewController: TodoViewController())
        case .stopwatch:
            viewController = .init(rootViewController: StopwatchController())
        }
        viewController.tabBarItem = tabbarItem
        return viewController
    }
}

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewControllers(TabbarItems.allCases.map { $0.navigationController }, animated: true)
    }
    
}
