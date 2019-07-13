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
        return navigationController
    }
    
    private var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = [Coordinator]()
    }
    
    func start() {
        let vc = SettingsViewController()
        vc.coordinator = self
        
        self.navigationController.pushViewController(vc, animated: false)
    }
    
}
