//
//  SettingsCoordinator.swift
//  CurrentNewsFeed
//
//  Created by Matheus Oliveira Costa on 12/07/19.
//  Copyright © 2019 Matheus Costa. All rights reserved.
//

import UIKit

final class SettingsCoordinator: Coordinator {

    var childCoordinators: [Coordinator]?

    var rootViewController: UIViewController {
        return self.navigationController
    }

    private var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.tabBarItem = UITabBarItem(
            title: "Settings", image: UIImage(named: "settings"), tag: 2)

    }

    func start() {
        // This is necessary to check if the coordinator is already started,
        // if so, prevents to push the same view controller over and over
        guard self.navigationController.topViewController == nil else { return }

        let viewController = SettingsViewController()
        viewController.coordinator = self

        self.navigationController.pushViewController(viewController, animated: false)
    }

}
