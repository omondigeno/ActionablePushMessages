//
//  MessageList.swift
//  PushedActionableMessages
//
//  Created by Samuel Geno on 12/04/2016.
//  Copyright © 2016 Geno. All rights reserved.
//

import Foundation
import UIKit
import MK
import SnapKit

class MessageList: UITableView, UITableViewDataSource, UITableViewDelegate {
    
    var list: [Message] = []
    
    convenience init(superView: UIView) {
        self.init(frame: CGRect.zero)
        self.delegate      =   self
        self.dataSource    =   self
        self.registerClass(MessageView.self, forCellReuseIdentifier: "cell")
        self.backgroundColor = UIColor.clearColor()
        self.tableFooterView = UIView(frame: CGRectZero)
        self.separatorColor = UIColor.clearColor()

        superView.addSubview(self)
        self.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(superView)
            make.width.equalTo(Common.dimensionWidth())
            make.bottom.equalTo(-70)
        }
        
    }
       
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! MessageView
        
        let row = indexPath.row
        
        cell.messageLabel.text = list[row].message
       
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = list[row].message
        cell.textLabel?.font = UIFont.systemFontOfSize(20);
        cell.textLabel?.textColor = MaterialColor.white

        
        if list[row].sender == Utils.getUUID(){
            cell.messageLabel.snp_makeConstraints { (make) -> Void in
                make.left.equalTo(30)
                make.height.equalTo(cell.textLabel!)
                make.width.equalTo(Common.dimensionWidth()-30)
            }
             cell.messageLabel.layer.backgroundColor = MaterialColor.blue.accent3.CGColor
        }else{
            cell.messageLabel.snp_makeConstraints { (make) -> Void in
                make.left.equalTo(0)
                make.height.equalTo(cell.textLabel!)
 make.width.equalTo(Common.dimensionWidth()-30)
            }
            cell.messageLabel.layer.backgroundColor = MaterialColor.grey.darken3.CGColor
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
     return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func addMessage(message: Message) {
        list.append(message)
        reloadData()
        self.snp_updateConstraints { (make) -> Void in
          //  make.top.equalTo(100)
            make.centerX.equalTo(superview!)
          //  make.width.equalTo(Common.dimensionWidth())
             make.height.equalTo(self.contentSize.height+40)
           // make.bottom.equalTo(-70)
        }
    }
}