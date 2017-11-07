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
			DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(2 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)) { () -> Void in
				wrapper.didFinishRefreshing()
			}
		}
		view = wrapper
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.navigationItem.title = "Bananas"
		self.navigationController?.navigationBar.titleTextAttributes = [
			NSForegroundColorAttributeName : UIColor.white,
			NSFontAttributeName : UIFont.systemFont(ofSize: 18.0, weight: UIFontWeightBold)
		];
		self.navigationController?.navigationBar.isTranslucent = false
		self.navigationController?.navigationBar.shadowImage = UIImage()
		self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
		self.navigationController?.navigationBar.barTintColor = UIColor.purple
	}
}

class NavigationController: UINavigationController {
	override var preferredStatusBarStyle : UIStatusBarStyle {
		return .lightContent
	}
}
