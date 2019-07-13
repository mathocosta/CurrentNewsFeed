//
//  AppDelegate.swift
//  CurrentNewsFeed
//
//  Created by Matheus Costa on 16/10/18.
//  Copyright © 2018 Matheus Costa. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Checking if a default feed is already configured.
        let defaults = UserDefaults.standard
        if defaults.object(forKey: "MainFeedURL") == nil {
            defaults.set(APIEndpoints.topstories.rawValue, forKey: "MainFeedURL")
        }
        
        self.window = UIWindow()
        self.window?.makeKeyAndVisible()
        
        let tabBarController = UITabBarController()
        let appCoordinator = AppCoordinator(tabBarController: tabBarController)
        appCoordinator.start()
        
        self.window?.rootViewController = tabBarController
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        DataManager.saveContext()
    }

}

