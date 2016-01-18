//
//  ViewController.swift
//  ElasticPullToRefresh
//
//  Created by Joshua Tessier on 2015-12-20.
//  Copyright © 2015 Shorts. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	override func loadView() {
		let tableView = UITableView()
		let wrapper = ElasticPullToRefresh(scrollView: tableView)
		wrapper.didPullToRefresh = {
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2 * NSEC_PER_SEC)), dispatch_get_main_queue()) { () -> Void in
				wrapper.didFinishRefreshing()
			}
		}
		view = wrapper
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		self.navigationItem.title = "Bananas"
		self.navigationController?.navigationBar.titleTextAttributes = [
			NSForegroundColorAttributeName : UIColor.whiteColor(),
			NSFontAttributeName : UIFont.systemFontOfSize(18.0, weight: UIFontWeightBold)
		];
		self.navigationController?.navigationBar.translucent = false
		self.navigationController?.navigationBar.shadowImage = UIImage()
		self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
		self.navigationController?.navigationBar.barTintColor = UIColor.purpleColor()
	}
}

class NavigationController: UINavigationController {
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return .LightContent
	}
}
