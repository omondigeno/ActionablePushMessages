//
//  ViewController.swift
//  PushedActionableMessages
//
//  Created by Samuel Geno on 10/04/2016.
//  Copyright © 2016 Geno. All rights reserved.
//

import UIKit
import MK
import SnapKit

class ViewController: UIViewController {
    
    var messageList: MessageList?
    let chatTextView = UITextView(frame: CGRectZero)

    override func viewDidLoad() {
        super.viewDidLoad()
view.backgroundColor = UIColor.whiteColor()
        let materialView: MaterialView = MaterialView(frame:  CGRectZero)
        materialView.shape = .Square
        materialView.backgroundColor = UIColor.brandColor
        
        view.addSubview(materialView)
        materialView.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(view)
            make.width.equalTo(view)
            make.height.equalTo(5)
            make.top.equalTo(80)
 }
        
        let imageView = UIImageView(frame: CGRectZero)
        imageView.contentMode = .ScaleAspectFit
        imageView.image = UIImage(named: "logo")
        view.addSubview(imageView)
        imageView.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(view)
            make.width.equalTo(138)
            make.height.equalTo(60)
            make.top.equalTo(10)
 }
        
         messageList = MessageList(superView: view)
        
        chatTextView.layer.cornerRadius = 5
        chatTextView.layer.borderWidth = 2
        chatTextView.layer.borderColor = UIColor.brandColor.CGColor
        chatTextView.font = UIFont.systemFontOfSize(20);
        
    
        view.addSubview(chatTextView)
  chatTextView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(5)
            make.height.equalTo(60)
            make.bottom.equalTo(-5)
            make.right.equalTo(-70)

        }
        
        let sendButton = RaisedButton(frame: CGRectZero)
        sendButton.addTarget(self, action: "send:", forControlEvents: .TouchUpInside)
        sendButton.pulseScale = true
        sendButton.pulseFill = true
        sendButton.pulseColor = MaterialColor.white
        sendButton.cornerRadius = .Radius2
        sendButton.backgroundColor = UIColor.brandColor
        sendButton.setImage(UIImage(named: "ic_arrow_forward"), forState: .Normal)
        view.addSubview(sendButton)
        sendButton.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(60)
            make.height.equalTo(60)
            make.bottom.equalTo(-5)
            make.right.equalTo(-5)
            
        }
      

    }
    
    func send(sender:UIButton){
        if chatTextView.text.characters.count > 0 {
        messageList?.addMessage(Message(message:chatTextView.text, sender: Utils.getUUID()))
            //# TODO: actually send to another device and only then can we delete message from textview
        chatTextView.text = ""
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

