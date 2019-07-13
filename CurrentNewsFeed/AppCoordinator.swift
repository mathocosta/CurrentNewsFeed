//
//  AppCoordinator.swift
//  CurrentNewsFeed
//
//  Created by Matheus Oliveira Costa on 12/07/19.
//  Copyright © 2019 Matheus Costa. All rights reserved.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator]
    
    var rootViewController: UIViewController {
        return self.tabBarController
    }
    
    var tabBarController: UITabBarController
    
    init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
        self.childCoordinators = [Coordinator]()
    }
    
    func start() {
        let settingsCoordinator = SettingsCoordinator(navigationController: UINavigationController())
        let settingsNavigationController = settingsCoordinator.rootViewController
        let itemImage = UIImage(named: "settings")
        settingsNavigationController.tabBarItem = UITabBarItem(title: "Settings", image: itemImage, tag: 0)
        
        self.tabBarController.viewControllers = [settingsNavigationController]
        self.tabBarController.tabBar.isTranslucent = false
        
        settingsCoordinator.start()
    }
    
}
