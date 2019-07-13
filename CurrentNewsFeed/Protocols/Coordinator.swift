//
//  Coordinator.swift
//  CurrentNewsFeed
//
//  Created by Matheus Oliveira Costa on 12/07/19.
//  Copyright © 2019 Matheus Costa. All rights reserved.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var rootViewController: UIViewController { get }
    
    func start()
}
