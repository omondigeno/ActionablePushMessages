//
//  MessageLabel.swift
//  PushedActionableMessages
//
//  Created by Samuel Geno on 12/04/2016.
//  Copyright © 2016 Geno. All rights reserved.
//
import UIKit

/// Label view used to display chat messages in list
class MessageLabel: UILabel {
    
    override init (frame : CGRect) {
        super.init(frame : frame)
        
        self.textColor = UIColor.whiteColor()
        self.font = UIFont.systemFontOfSize(18);
        self.layer.cornerRadius = 5
        self.lineBreakMode = .ByWordWrapping
        self.numberOfLines = 0

    }
    
    convenience init () {
        self.init(frame:CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    override func drawTextInRect(rect: CGRect) {
        ///Ensure enough padding between text content and edges
    super.drawTextInRect(
    rect.insetBy(dx: 10, dy: 10).integral)
    }
}