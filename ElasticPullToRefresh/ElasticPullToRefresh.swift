//
//  ElasticPullToRefresh.swift
//  ElasticPullToRefresh
//
//  Created by Joshua Tessier on 2015-12-20.
//  Copyright © 2015-2018 Joshua Tessier. All rights reserved.
//

import UIKit

public class ElasticPullToRefresh: UIView, UIGestureRecognizerDelegate {
	public let scrollView: UIScrollView
	public var didPullToRefresh: (()->())?
	
	public var pullDistance: CGFloat = 66
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
	private var isRefreshing = false
	private var isAnimating = false
	private var originalInsets = UIEdgeInsetsMake(0, 0, 0, 0)
	private var context = "ElasticPullToRefreshContext"
	
	convenience public init(scrollView: UIScrollView) {
		self.init(frame: .zero, scrollView: scrollView)
	}
	
	public init(frame: CGRect, scrollView: UIScrollView) {
		self.scrollView = scrollView
		super.init(frame: frame)
		
		backgroundColor = scrollView.backgroundColor
		scrollView.backgroundColor = .clear
		
		addSubview(scrollView)
		addSubview(bounceView)
		
		scrollView.addObserver(self, forKeyPath: "contentOffset", options: .initial, context: &context)
		scrollView.addObserver(self, forKeyPath: "contentInset", options: .initial, context: &context)
		
		let selector = #selector(didPan(gestureRecognizer:))
		let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: selector)
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
		handleScroll()
		bounceView.bend(x: touchX, y: 0)
	}
	
	// MARK: Refreshing
	
	private func startRefreshing() {
		isRefreshing = true
		bounceView.indicator.set(animating: true)
	}
	
	public func didFinishRefreshing() {
		scrollView.isScrollEnabled = false
		
		isRefreshing = false
		updateContentInsets(insets: originalInsets)
		bounceView.indicator.set(animating: false)
		
		scrollView.isScrollEnabled = true
	}
	
	// MARK: Gesture Recognizers
	
	@objc private func didPan(gestureRecognizer: UIPanGestureRecognizer) {
		if gestureRecognizer.state == .ended {
			if isRefreshing {
				updateContentInsets(insets: UIEdgeInsetsMake(originalInsets.top + pullDistance, 0, 0, 0))
			}
		}
		else {
			touchX = gestureRecognizer.location(in: self).x
		}
	}
	
	// MARK: Observing
	
	public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		if (context == &self.context) {
			if isRefreshing == false && keyPath == "contentOffset" {
				handleScroll()
			}
			else if keyPath == "contentInset" {
				handleContentInsetUpdate()
			}
		}
		else {
			super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
		}
	}
	
	// MARK: Helpers
	
	private func handleContentInsetUpdate() {
		originalInsets = scrollView.contentInset
	}
	
	private func updateContentInsets(insets: UIEdgeInsets) {
		isAnimating = true
		scrollView.removeObserver(self, forKeyPath: "contentInset")
		UIView.animate(withDuration: animationDuration, animations: {
			self.scrollView.contentInset = insets
		}) { (completed: Bool) -> Void in
			self.isAnimating = false
			self.handleScroll()
		}
		scrollView.addObserver(self, forKeyPath: "contentInset", options: .new, context: &context)
	}
	
	private func handleScroll() {
		let y = (isAnimating ? 0 : (scrollView.contentOffset.y * -1)) - scrollView.contentInset.top
		let bounds = self.bounds
		bounceView.frame = CGRect(x: bounds.minX, y: min(bounds.origin.y + scrollView.contentInset.top + min(y - pullDistance, 0), 0), width: bounds.size.width, height: pullDistance)
		
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
	
	public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return true
	}
}
