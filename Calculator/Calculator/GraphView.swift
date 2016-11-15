//
//  GraphView.swift
//  Calculator
//
//  Created by Mohamed Hamza on 7/11/16.
//  Copyright © 2016 Mohamed Hamza. All rights reserved.
//

import UIKit

protocol GraphViewDelegate {
    func xToY(x: Double) -> Double
}

@IBDesignable class GraphView: UIView {
    
    var delegate: GraphViewDelegate?
    
    @IBInspectable
    var scale: CGFloat = 50.0 {
        didSet{
            setNeedsDisplay()
        }
    }
    
    
    @IBInspectable
    var originPoint: CGPoint? {
        didSet{
            setNeedsDisplay()
        }
    }
    
    var origin: CGPoint {
        get {
            return originPoint ?? CGPoint(x: bounds.midX, y: bounds.midY)
        }
    }
    
    override func drawRect(rect: CGRect) {
        AxesDrawer(color: UIColor.blackColor(), contentScaleFactor: contentScaleFactor).drawAxesInRect(bounds, origin: origin, pointsPerUnit: scale)
        if delegate == nil { return }
        let path = UIBezierPath()
        path.lineWidth = 3.0
        UIColor.redColor().set()
        var xDisplay: CGFloat = 0.0
        var y = delegate!.xToY(Double((xDisplay - origin.x) / scale))
        var yDisplay = (origin.y - (CGFloat(y) * scale))
        path.moveToPoint(CGPoint(x: xDisplay, y: yDisplay))
        while xDisplay <= bounds.maxX {
            y = delegate!.xToY(Double((xDisplay - origin.x) / scale))
            yDisplay = (origin.y - (CGFloat(y) * scale))
            path.addLineToPoint(CGPoint(x: xDisplay, y: yDisplay))
            xDisplay += 1
        }
        path.stroke()
    }

}
