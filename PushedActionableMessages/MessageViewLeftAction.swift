//
//  MessageViewLeftAction.swift
//  PushedActionableMessages
//
//  Created by Samuel Geno on 18/04/2016.
//  Copyright © 2016 Geno. All rights reserved.
//

import Foundation
import UIKit
import MK

///A reusable view used to display messages with actions to the left of the message list
class MessageViewLeftAction: MessageViewLeft {
    
    /// initialize with rect = 0 because autolayout will take care of setting height 
    var bgView = UIView(frame: CGRectZero)
    ///Prompts user to action
    let actionButton = ActionButton(title: "")
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
       ///Insert background view behind message label for message to be visible
        self.insertSubview(bgView, belowSubview: messageLabel)
        
        bgView.translatesAutoresizingMaskIntoConstraints = false
        
        bgView.snp_updateConstraints { (make) -> Void in
            make.left.equalTo(10)
            make.bottom.equalTo(self.snp_bottom).offset(-2)
            make.height.equalTo(118)
            make.width.equalTo(Common.dimensionWidth()-30)
        }
        bgView.layer.backgroundColor = MaterialColor.grey.darken1.CGColor
        bgView.layer.cornerRadius = 5
        
        self.addSubview(actionButton)
        actionButton.snp_updateConstraints { (make) -> Void in
            make.right.equalTo(-40)
            make.bottom.equalTo(self.snp_bottom).offset(-12)
            make.height.equalTo(30)
            make.width.equalTo(100)
            
        }
        
       ///still not supporting automatic height for messages with actions
        messageLabel.snp_updateConstraints { (make) -> Void in
           make.height.equalTo(90)
        }
        
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    /**
     Sets button title
     
     - Parameters:
     - title: title to display
     */
    func setActionButtonTitle(title: String){
        actionButton.setTitle(title, forState: .Normal)
    }
    
}