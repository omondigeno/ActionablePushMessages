//
//  Common.swift
//  PushedActionableMessages
//
//  Created by Samuel Geno on 10/04/2016.
//  Copyright © 2016 Geno. All rights reserved.
//

import Foundation
import UIKit
import PKHUD

class Common {
    
    class func showMessage (message: String, viewController: UIViewController) {
        viewController.view.dodo.style.label.color = UIColor.whiteColor()
        viewController.view.dodo.style.bar.backgroundColor = UIColor.brandColor
        viewController.view.dodo.style.bar.hideAfterDelaySeconds = 10
        viewController.view.dodo.style.bar.locationTop = false
        viewController.view.dodo.style.bar.cornerRadius = 0
        viewController.view.dodo.style.bar.marginToSuperview = CGSizeMake(10, 100)
        viewController.view.dodo.info(message)
        
    }
    class func showMessage (message: String, viewController: UIViewController, action: ()->()) {
        viewController.view.dodo.style.label.color = UIColor.whiteColor()
        viewController.view.dodo.style.bar.backgroundColor = UIColor.brandColor
        viewController.view.dodo.style.leftButton.icon = .Close
        viewController.view.dodo.style.leftButton.hideOnTap = true
        viewController.view.dodo.style.rightButton.icon = .Reload
        viewController.view.dodo.style.rightButton.onTap = action
        viewController.view.dodo.style.rightButton.hideOnTap = true
        viewController.view.dodo.style.bar.locationTop = false
        viewController.view.dodo.style.bar.cornerRadius = 0
        viewController.view.dodo.style.bar.marginToSuperview = CGSizeMake(10, 100)
        viewController.view.dodo.info(message)
        
    }
    class func showProgress (viewController: UIViewController) {
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
    }
    class func hideProgress (viewController: UIViewController) {
        PKHUD.sharedHUD.hide(animated: false, completion: nil);
        
    }
}

let payIdentifier = "PAY_IDENTIFIER"