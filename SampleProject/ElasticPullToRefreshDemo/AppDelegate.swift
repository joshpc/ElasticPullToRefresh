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
	
	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		window = UIWindow(frame: UIScreen.mainScreen().bounds)
		window?.rootViewController = UINavigationController(rootViewController: ViewController())
		window?.makeKeyAndVisible()
		
		return true
	}
}

