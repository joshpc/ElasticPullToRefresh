//
//  BounceView.swift
//  ElasticPullToRefresh
//
//  Created by Joshua Tessier on 2015-12-20.
//  Copyright © 2015-2018 Joshua Tessier. All rights reserved.
//

import UIKit

class BounceView: UIView, CAAnimationDelegate {
	private var bendLayer: CAShapeLayer!
	private var indicatorConstraints = [NSLayoutConstraint]()
	
	let indicator = IndicatorView()
	var indicatorSize = CGSize(width: 30.0, height: 30.0) {
		didSet {
			updateIndicatorConstraints()
		}
	}
	
	var fillColor: UIColor? {
		didSet {
			bendLayer.fillColor = (fillColor ?? .purple).cgColor
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		setupViews()
		updateIndicatorConstraints()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		setupViews()
		updateIndicatorConstraints()
	}
	
	private func setupViews() {
		bendLayer = CAShapeLayer(layer: self.layer)
		bendLayer.lineWidth = 0
		bendLayer.path = bendPath(x: 0.0, y: 0.0)
		bendLayer.fillColor = UIColor.purple.cgColor
		
		layer.addSublayer(bendLayer)
		addSubview(indicator)
	}
	
	private func updateIndicatorConstraints() {
		NSLayoutConstraint.deactivate(indicatorConstraints)
		indicatorConstraints.removeAll()
		
		indicatorConstraints.append(indicator.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor))
		indicatorConstraints.append(indicator.heightAnchor.constraint(equalToConstant: indicatorSize.height))
		indicatorConstraints.append(indicator.widthAnchor.constraint(equalToConstant: indicatorSize.width))
		indicatorConstraints.append(indicator.topAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -(indicatorSize.height * 1.5)))
		
		NSLayoutConstraint.activate(indicatorConstraints)
	}
	
	func bend(x: CGFloat, y: CGFloat) {
		bendLayer.path = bendPath(x: x, y: y)
	}
	
	func bounce(fromX currentX: CGFloat, fromY currentY: CGFloat, duration: Double) {
		bend(x: bounds.midX, y: 0.0)
		
		let deltaX = currentX - bounds.midX
		let bounce = CAKeyframeAnimation(keyPath: "path")
		bounce.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
		let values = [
			bendPath(x: currentX, y: currentY),
			bendPath(x: currentX + deltaX * 0.1, y: currentY),
			bendPath(x: currentX + deltaX * 0.4, y: 20),
			bendPath(x: currentX + deltaX * 0.7, y: -20),
			bendPath(x: currentX + deltaX * 0.9, y: 10),
			bendPath(x: currentX + deltaX * 1.0, y: 0)
		]
		bounce.values = values
		bounce.duration = duration
		bounce.isRemovedOnCompletion = true
		bounce.fillMode = kCAFillModeForwards
		bounce.delegate = self
		bendLayer.add(bounce, forKey: "bounce")
	}
	
	private func bendPath(x: CGFloat, y: CGFloat) -> CGPath {
		let bezierPath = UIBezierPath()
		
		let tip = CGPoint(x: bounds.minX + x, y: bounds.maxY + y)
		let tipMinX = round(tip.x - bounds.width * 0.7)
		let tipMaxX = round(tip.x + bounds.width * 0.7)
		let minX = min(bounds.minX - 20, tipMinX)
		let maxX = max(bounds.maxX + 20, tipMaxX)
		
		bezierPath.move(to: CGPoint(x: minX, y: bounds.minY))
		bezierPath.addLine(to: CGPoint(x: maxX, y: bounds.minY))
		bezierPath.addLine(to: CGPoint(x: maxX, y: bounds.maxY))
		
		bezierPath.addQuadCurve(to: tip, controlPoint: CGPoint(x: tipMaxX, y: tip.y))
		bezierPath.addQuadCurve(to: CGPoint(x: bounds.minX, y: bounds.maxY), controlPoint: CGPoint(x: tipMinX, y: tip.y))
		return bezierPath.cgPath
	}
}
