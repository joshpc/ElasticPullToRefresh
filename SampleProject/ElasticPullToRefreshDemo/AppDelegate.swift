//
//  AppDelegate.swift
//  ElasticPullToRefresh
//
//  Created by Joshua Tessier on 2015-12-20.
//  Copyright © 2015 Shorts. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		window = UIWindow(frame: UIScreen.main.bounds)
		window?.rootViewController = NavigationController(rootViewController: ViewController())
		window?.makeKeyAndVisible()
		
		return true
	}
}

