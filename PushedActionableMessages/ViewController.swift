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

    override func viewDidLoad() {
        super.viewDidLoad()
view.backgroundColor = UIColor.whiteColor()
        let materialView: MaterialView = MaterialView(frame:  CGRectZero)
        materialView.shape = .Square
        materialView.cornerRadius = .Radius3
        materialView.borderColor = UIColor.brandColor
        materialView.borderWidth = MaterialBorder.Border3
        materialView.backgroundColor = UIColor.whiteColor()
        
        view.addSubview(materialView)
        materialView.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(view)
            make.width.equalTo(184)
            make.height.equalTo(80)
        }
        
        let imageView = UIImageView(frame: CGRectZero)
        imageView.contentMode = .ScaleAspectFit
        imageView.image = UIImage(named: "logo")
        view.addSubview(imageView)
        imageView.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(view)
            make.width.equalTo(138)
            make.height.equalTo(60)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

