//
//  NewsFeedCoordinator.swift
//  CurrentNewsFeed
//
//  Created by Matheus Oliveira Costa on 13/07/19.
//  Copyright © 2019 Matheus Costa. All rights reserved.
//

import UIKit

class NewsFeedCoordinator: Coordinator {

    var childCoordinators: [Coordinator]?

    var rootViewController: UIViewController {
        return self.navigationController
    }

    private var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.tabBarItem = UITabBarItem(tabBarSystemItem: .mostRecent, tag: 0)
    }

    func start() {
        // This is necessary to check if the coordinator is already started,
        // if so, prevents to push the same view controller over and over
        guard self.navigationController.topViewController == nil else { return }

        let viewController = NewsFeedViewController()
        viewController.coordinator = self

        self.navigationController.pushViewController(viewController, animated: false)
    }

    func showDetails(of item: Item) {
        let viewController = ItemViewController(item: item)
        viewController.coordinator = self

        self.navigationController.pushViewController(viewController, animated: true)
    }

}
