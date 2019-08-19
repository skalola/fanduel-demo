//
//  AppDelegate.swift
//  FD_iOS_takehome
//
//  Created by Phil Milot on 4/24/19.
//  Copyright © 2019 FanDuel. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let gamesViewController = GamesViewController()
        let nav = UINavigationController(rootViewController: gamesViewController)
        window?.rootViewController = nav
        
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
        UserDefaults.standard.removeObject(forKey: "game_id")
        UserDefaults.standard.removeObject(forKey: "playerRows")
        UserDefaults.standard.synchronize()
    }


}

