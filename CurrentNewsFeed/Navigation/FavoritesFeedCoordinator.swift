//
//  FavoritesFeedCoordinator.swift
//  CurrentNewsFeed
//
//  Created by Matheus Oliveira Costa on 14/07/19.
//  Copyright © 2019 Matheus Costa. All rights reserved.
//

import UIKit

class FavoritesFeedCoordinator: Coordinator {

    var childCoordinators: [Coordinator]?

    var rootViewController: UIViewController {
        return self.navigationController
    }

    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
    }

    func start() {
        // This is necessary to check if the coordinator is already started,
        // if so, prevents to push the same view controller over and over
        guard self.navigationController.topViewController == nil else { return }

        let vc = FavoritesFeedViewController()
        vc.coordinator = self

        self.navigationController.pushViewController(vc, animated: true)
    }

    func showDetails(of item: Item) {
        guard let favoritesFeedViewController = self.navigationController.topViewController as? FavoritesFeedViewController else { return }
        let vc = ItemViewController(item: item)
        vc.coordinator = self
        vc.delegate = favoritesFeedViewController

        self.navigationController.pushViewController(vc, animated: true)
    }

}
