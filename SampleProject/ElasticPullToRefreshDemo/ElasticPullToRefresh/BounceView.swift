//
//  BounceView.swift
//  ElasticPullToRefresh
//
//  Created by Joshua Tessier on 2015-12-20.
//  Copyright © 2015 Joshua Tessier. All rights reserved.
//

import UIKit

class BounceView: UIView {
	private var bendLayer: CAShapeLayer!
	let indicator = IndicatorView()
	var indicatorSize: CGSize = CGSizeMake(30.0, 30.0)
	var fillColor: UIColor? {
		didSet {
			bendLayer.fillColor = (fillColor ?? UIColor.purpleColor()).CGColor
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		bendLayer = CAShapeLayer(layer: self.layer)
		bendLayer.lineWidth = 0
		bendLayer.path = bendPath(x: 0.0, y: 0.0)
		bendLayer.fillColor = UIColor.purpleColor().CGColor
		
		layer.addSublayer(bendLayer)
		addSubview(indicator)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		indicator.frame = CGRectMake(bounds.origin.x + round((bounds.size.width - indicatorSize.width) * 0.5), bounds.maxY - indicatorSize.height - 15.0, indicatorSize.width, indicatorSize.height)
	}
	
	func bend(x x: CGFloat, y: CGFloat) {
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
		bounce.removedOnCompletion = true
		bounce.fillMode = kCAFillModeForwards
		bounce.delegate = self
		bendLayer.addAnimation(bounce, forKey: "bounce")
	}
	
	private func bendPath(x x: CGFloat, y: CGFloat) -> CGPathRef {
		let bezierPath = UIBezierPath()
		
		let tip = CGPointMake(bounds.minX + x, bounds.maxY + y)
		let tipMinX = round(tip.x - bounds.width * 0.7)
		let tipMaxX = round(tip.x + bounds.width * 0.7)
		let minX = min(bounds.minX - 20, tipMinX)
		let maxX = max(bounds.maxX + 20, tipMaxX)
		
		bezierPath.moveToPoint(CGPointMake(minX, bounds.minY))
		bezierPath.addLineToPoint(CGPointMake(maxX, bounds.minY))
		bezierPath.addLineToPoint(CGPointMake(maxX, bounds.maxY))
		
		bezierPath.addQuadCurveToPoint(tip, controlPoint: CGPointMake(tipMaxX, tip.y))
		bezierPath.addQuadCurveToPoint(CGPointMake(bounds.minX, bounds.maxY), controlPoint: CGPointMake(tipMinX, tip.y))
		return bezierPath.CGPath
	}
}
