//
//  RefreshView.swift
//  ElasticPullToRefresh
//
//  Created by Joshua Tessier on 2015-12-20.
//  Copyright © 2015-2018 Joshua Tessier. All rights reserved.
//

import UIKit

public class IndicatorView: UIView {
	private let circleLayer = CAShapeLayer()
	
	private var animating: Bool = false
	
	public var indicatorTintColor: UIColor? {
		didSet {
			circleLayer.strokeColor = (tintColor ?? UIColor.white).cgColor
		}
	}
	
	var interactiveProgress: CGFloat = 0.0 {
		didSet {
			circleLayer.strokeStart = 0
			circleLayer.strokeEnd = interactiveProgress
		}
	}
	
	private let strokeAnimations: CAAnimation = {
		let startAnimation = CABasicAnimation(keyPath: "strokeStart")
		startAnimation.beginTime = 0.5
		startAnimation.fromValue = 0
		startAnimation.toValue = 1
		startAnimation.duration = 1.5
		startAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
		
		let endAnimation = CABasicAnimation(keyPath: "strokeEnd")
		endAnimation.fromValue = 0
		endAnimation.toValue = 1
		endAnimation.duration = 2
		endAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
		
		let group = CAAnimationGroup()
		group.duration = 2.5
		group.repeatCount = MAXFLOAT
		group.animations = [startAnimation, endAnimation]
		
		return group
	}()
	
	private let rotationAnimation: CAAnimation = {
		let animation = CABasicAnimation(keyPath: "transform.rotation.z")
		animation.fromValue = 0
		animation.toValue = CGFloat.pi * 2
		animation.duration = 4
		animation.repeatCount = MAXFLOAT
		return animation
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupViews()
	}

	public required init?(coder aDecoder: NSCoder) {
	    super.init(coder: aDecoder)
		setupViews()
	}
	
	private func setupViews() {
		translatesAutoresizingMaskIntoConstraints = false
		
		circleLayer.lineWidth = 2
		circleLayer.fillColor = nil
		circleLayer.strokeColor = UIColor.white.cgColor
		circleLayer.strokeStart = 0
		circleLayer.strokeEnd = 0
		layer.addSublayer(circleLayer)
	}
	
	public override func layoutSubviews() {
		super.layoutSubviews()
		
		let center = CGPoint(x: bounds.midX, y: bounds.midY)
		let radius = min(bounds.width, bounds.height) / 2 - circleLayer.lineWidth / 2
		
		let startAngle = -CGFloat.pi / 2
		let endAngle = startAngle + (2 * CGFloat.pi)
		let path = UIBezierPath(arcCenter: .zero, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
		
		circleLayer.position = center
		circleLayer.path = path.cgPath
	}
	
	func set(animating: Bool) {
		self.interactiveProgress = 0.0
		self.animating = animating
		updateAnimation()
	}
	
	private func updateAnimation() {
		if animating {
			circleLayer.add(strokeAnimations, forKey: "strokes")
			circleLayer.add(rotationAnimation, forKey: "rotation")
		}
		else {
			circleLayer.removeAnimation(forKey: "strokes")
			circleLayer.removeAnimation(forKey: "rotation")
		}
	}
}
