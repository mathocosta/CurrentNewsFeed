//
//  AppCoordinator.swift
//  CurrentNewsFeed
//
//  Created by Matheus Oliveira Costa on 12/07/19.
//  Copyright © 2019 Matheus Costa. All rights reserved.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator]?
    
    var rootViewController: UIViewController {
        return self.tabBarController
    }
    
    var tabBarController: UITabBarController
    
    init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
        self.childCoordinators = [
            FavoritesFeedCoordinator(navigationController: UINavigationController()),
            NewsFeedCoordinator(navigationController: UINavigationController()),
            SettingsCoordinator(navigationController: UINavigationController())
        ]

        self.tabBarController.viewControllers = self.childCoordinators?.map({ $0.rootViewController })
        self.tabBarController.tabBar.isTranslucent = false
    }
    
    func start() {
        let firstCoordinator = self.childCoordinators?.first
        firstCoordinator?.start()
    }

    func showTab(at index: Int) {
        let coordinator = self.childCoordinators?[index]
        coordinator?.start()
    }
    
}
