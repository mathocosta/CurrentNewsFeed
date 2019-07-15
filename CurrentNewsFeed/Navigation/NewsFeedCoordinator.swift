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

        let vc = NewsFeedViewController()
        vc.coordinator = self

        self.navigationController.pushViewController(vc, animated: false)
    }

    func showDetails(of item: Item) {
        let vc = ItemViewController(item: item)
        vc.coordinator = self

        self.navigationController.pushViewController(vc, animated: true)
    }

}
