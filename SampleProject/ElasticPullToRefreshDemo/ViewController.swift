//
//  ViewController.swift
//  ElasticPullToRefresh
//
//  Created by Joshua Tessier on 2015-12-20.
//  Copyright © 2015-2018. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	override func loadView() {
		let tableView = UITableView()
		let wrapper = ElasticPullToRefresh(scrollView: tableView)
		wrapper.didPullToRefresh = {
			DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(2)) {
				wrapper.didFinishRefreshing()
			}
		}
		view = wrapper
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.navigationItem.title = "Bananas"
		self.navigationController?.navigationBar.titleTextAttributes = [
			NSAttributedStringKey.foregroundColor : UIColor.white,
			NSAttributedStringKey.font : UIFont.systemFont(ofSize: 18.0, weight: .bold)
		];
		self.navigationController?.navigationBar.isTranslucent = false
		self.navigationController?.navigationBar.shadowImage = UIImage()
		self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
		self.navigationController?.navigationBar.barTintColor = UIColor.purple
	}
}

class NavigationController: UINavigationController {
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
}
