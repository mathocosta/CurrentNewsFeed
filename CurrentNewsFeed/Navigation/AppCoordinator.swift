//
//  AppCoordinator.swift
//  CurrentNewsFeed
//
//  Created by Matheus Oliveira Costa on 12/07/19.
//  Copyright © 2019 Matheus Costa. All rights reserved.
//

import UIKit

final class AppCoordinator: NSObject, Coordinator {
    
    var childCoordinators: [Coordinator]?
    
    var rootViewController: UIViewController {
        return self.tabBarController
    }
    
    var tabBarController: UITabBarController
    
    init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
        self.childCoordinators = [
            NewsFeedCoordinator(navigationController: UINavigationController()),
            FavoritesFeedCoordinator(navigationController: UINavigationController()),
            SettingsCoordinator(navigationController: UINavigationController())
        ]

        super.init()

        self.tabBarController.viewControllers = self.childCoordinators?.map({ $0.rootViewController })
        self.tabBarController.tabBar.isTranslucent = false
        self.tabBarController.delegate = self
    }

    func start() {
        let firstCoordinator = self.childCoordinators?.first
        firstCoordinator?.start()
    }
    
}

// MARK: - UITabBarControllerDelegate
extension AppCoordinator: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let coordinator = self.childCoordinators?.first(where: { $0.rootViewController == viewController })
        coordinator?.start()
    }

}
