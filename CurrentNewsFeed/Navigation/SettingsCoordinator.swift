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
        self.navigationController.navigationBar.prefersLargeTitles = true
        self.navigationController.tabBarItem = UITabBarItem(
            title: "Settings", image: UIImage(named: "settings"), tag: 1)
        self.navigationController.navigationItem.title = "Settings"
    }
    
    func start() {
        let vc = SettingsViewController()
        vc.coordinator = self
        
        self.navigationController.pushViewController(vc, animated: false)
    }
    
}
