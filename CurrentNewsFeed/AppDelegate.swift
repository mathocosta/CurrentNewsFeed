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


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Testing
        let firstFavorite = Favorite(context: DataManager.context)
        firstFavorite.title = "Olá teste de favoritos"
        firstFavorite.type = "story"
        firstFavorite.url = "www.exemple.com"
        firstFavorite.published = Date()
        firstFavorite.savedOn = Date()
        
        DataManager.saveContext()
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        DataManager.saveContext()
    }

}

