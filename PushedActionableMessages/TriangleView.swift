//
//  TriangleView.swift
//  PushedActionableMessages
//
//  Created by Samuel Geno on 17/04/2016.
//  Copyright © 2016 Geno. All rights reserved.
//

import Foundation
import UIKit

///Used to create caption image for chat messages
class TriangeView : UIView {
    
    ///background color
    var bgColor = UIColor.brandColor.CGColor
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
   
    /**
     Draws an upside-down triangle
     
     - Parameters:
     - rect: reactangle defined by this views frame within with it can draw
          */
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