//
//  ElasticPullToRefresh.swift
//  ElasticPullToRefresh
//
//  Created by Joshua Tessier on 2015-12-20.
//  Copyright © 2015 Joshua Tessier. All rights reserved.
//

import UIKit

public class RefreshWrapper: UIView, UIGestureRecognizerDelegate {
	public let scrollView: UIScrollView
	public var didPullToRefresh: (()->())?
	
	public var pullDistance: CGFloat = 88
	public var bendDistance: CGFloat = 22
	public var animationDuration: Double = 0.5
	public var indicatorSize: CGSize {
		set {
			bounceView.indicatorSize = newValue
		}
		get {
			return bounceView.indicatorSize
		}
	}
	
	public var fillColor: UIColor? {
		set {
			bounceView.fillColor = newValue
		}
		get {
			return bounceView.fillColor
		}
	}
	
	private let bounceView = BounceView()
	private var maxDistance: CGFloat {
		return pullDistance + bendDistance
	}
	private var touchX: CGFloat = 0.0
	private var refreshing = false
	
	private var context = "ElasticPullToRefreshContext"
	
	convenience public init(scrollView: UIScrollView) {
		self.init(frame: CGRectZero, scrollView: scrollView)
	}
	
	public init(frame: CGRect, scrollView: UIScrollView) {
		self.scrollView = scrollView
		super.init(frame: frame)
		
		backgroundColor = scrollView.backgroundColor
		scrollView.backgroundColor = UIColor.clearColor()
		
		addSubview(scrollView)
		addSubview(bounceView)
		
		scrollView.addObserver(self, forKeyPath: "contentOffset", options: .Initial, context: &context)
		
		let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "didPan:")
		panGestureRecognizer.delegate = self
		panGestureRecognizer.delaysTouchesBegan = false
		panGestureRecognizer.delaysTouchesEnded = false
		panGestureRecognizer.cancelsTouchesInView = false
		scrollView.addGestureRecognizer(panGestureRecognizer)
	}
	
	public required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override public func layoutSubviews() {
		super.layoutSubviews()
		scrollView.frame = bounds
	}
	
	// MARK: Refreshing
	
	private func startRefreshing() {
		refreshing = true
		scrollView.contentInset = UIEdgeInsetsMake(pullDistance, 0, 0, 0)
		bounceView.indicator.setAnimating(true)
	}
	
	func didFinishRefreshing() {
		refreshing = false
		scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
		bounceView.indicator.setAnimating(false)
	}
	
	// MARK: Gesture Recognizers
	
	func didPan(gestureRecognizer: UIPanGestureRecognizer) {
		touchX = gestureRecognizer.locationInView(self).x
	}
	
	// MARK: Observing
	
	public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<()>) {
		if (context == &self.context && keyPath == "contentOffset") {
			if refreshing == false {
				handleScroll()
			}
		}
		else {
			super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
		}
	}
	
	// MARK: Helpers
	
	private func handleScroll() {
		let y = scrollView.contentOffset.y * -1
		let bounds = self.bounds
		bounceView.frame = CGRectMake(bounds.minX, bounds.origin.y + min(y - pullDistance, 0), bounds.size.width, pullDistance)
		
		if y > 0 {
			if y < pullDistance {
				bounceView.indicator.interactiveProgress = min(1.0, y / maxDistance)
				bounceView.bend(x: touchX, y: 0)
			}
			else if y > maxDistance {
				startRefreshing()
				bounceView.bounce(fromX: touchX, fromY: min(y - pullDistance, bendDistance), duration: animationDuration)
				didPullToRefresh?()
			}
			else {
				bounceView.indicator.interactiveProgress = min(1.0, y / maxDistance)
				bounceView.bend(x: touchX, y: min(y - pullDistance, bendDistance))
			}
		}
	}
	
	// MARK: UIGestureRecognizerDelegate Methods
	
	public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return true
	}
}
