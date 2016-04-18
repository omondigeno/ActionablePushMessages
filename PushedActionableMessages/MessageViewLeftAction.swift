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

///A reusable view used to display table row content
class MessageViewLeftAction: MessageViewLeft {
    
    /// initialize message label with rect = 0 because autolayout will take care of setting height to wrap contents
    var bgView = UIView(frame: CGRectZero)
    let actionButton = ActionButton(title: "")
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.insertSubview(bgView, belowSubview: messageLabel)
        
        bgView.translatesAutoresizingMaskIntoConstraints = false
        
        bgView.snp_updateConstraints { (make) -> Void in
            make.left.equalTo(10)
            //make.top.equalTo(self.snp_bottom).offset(0)
            make.bottom.equalTo(self.snp_bottom).offset(-2)
            make.height.equalTo(118)
            make.width.equalTo(Common.dimensionWidth()-30)
        }
        bgView.layer.backgroundColor = MaterialColor.grey.darken1.CGColor
        bgView.layer.cornerRadius = 5
        
        self.addSubview(actionButton)
        actionButton.snp_updateConstraints { (make) -> Void in
            make.right.equalTo(-40)
            //make.top.equalTo(messageLabel.snp_bottom).offset(-30)
            make.bottom.equalTo(self.snp_bottom).offset(-12)
            make.height.equalTo(30)
            make.width.equalTo(100)
            //make.bottom.equalTo(-30)
            
        }
        
        messageLabel.snp_updateConstraints { (make) -> Void in
           make.height.equalTo(90)
        }
        
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    func setActionButtonTitle(title: String){
        actionButton.setTitle(title, forState: .Normal)
    }
    
}