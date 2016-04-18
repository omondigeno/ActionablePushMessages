//
//  ActionButton.swift
//  PushedActionableMessages
//
//  Created by Samuel Geno on 17/04/2016.
//  Copyright © 2016 Geno. All rights reserved.
//

import Foundation
import UIKit
import MK
import SnapKit

/// Button used to prompt user to action
class ActionButton: RaisedButton {
    
    override init (frame : CGRect) {
        super.init(frame : frame)
    }
    
    convenience init () {
        self.init(frame:CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    /**
     Initializes a new ActionButton
     
     - Parameters:
     - title: button title
     
     - Returns: the initialized ActionButton.
     */
    init(title: String) {
        super.init(frame: CGRect.zero)
        setTitle(title, forState: .Normal)
        ///add tap handler
        addTarget(self, action: "tapped:", forControlEvents: .TouchUpInside)
        pulseScale = true
        pulseFill = true
        pulseColor = MaterialColor.white
        cornerRadius = .Radius2
        shadowColor = UIColor.whiteColor()
        backgroundColor = UIColor.brandColor
    }
    func tapped(sender:UIButton){
        ///TODO: Handle actions
    }
}