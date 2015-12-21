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
		let wrapper = RefreshWrapper(scrollView: tableView)
		wrapper.didPullToRefresh = {
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(5 * NSEC_PER_SEC)), dispatch_get_main_queue()) { () -> Void in
				wrapper.didFinishRefreshing()
			}
		}
		view = wrapper
	}
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return .LightContent
	}
}
