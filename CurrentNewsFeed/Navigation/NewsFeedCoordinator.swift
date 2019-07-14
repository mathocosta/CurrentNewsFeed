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
    }

    func start() {
        let vc = NewsFeedViewController()
        vc.coordinator = self

        self.navigationController.pushViewController(vc, animated: false)
    }

    func showDetails(of item: Item) {
        let vc = ItemViewController(item: item)
        vc.coordinator = self
        vc.hidesBottomBarWhenPushed = true

        self.navigationController.pushViewController(vc, animated: true)
    }

}
