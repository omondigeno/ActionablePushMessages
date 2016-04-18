//
//  TriangleView.swift
//  PushedActionableMessages
//
//  Created by Samuel Geno on 17/04/2016.
//  Copyright © 2016 Geno. All rights reserved.
//

import Foundation
import UIKit

class TriangeView : UIView {
    
    var bgColor = UIColor.brandColor.CGColor
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func drawRect(rect: CGRect) {

        if let ctx = UIGraphicsGetCurrentContext() {
        CGContextBeginPath(ctx)
        CGContextMoveToPoint(ctx, CGRectGetMinX(rect), CGRectGetMinY(rect))
        CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMinY(rect))
        CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect)/2.0, CGRectGetMaxY(rect))
        CGContextClosePath(ctx)
        
        CGContextSetFillColorWithColor(ctx, bgColor);
        CGContextFillPath(ctx);
        }
    }
    
}