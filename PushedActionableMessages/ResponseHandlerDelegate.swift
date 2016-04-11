//
//  ResponseHandlerDelegate.swift
//  PushedActionableMessages
//
//  Created by Samuel Geno on 10/04/2016.
//  Copyright © 2016 Geno. All rights reserved.
//

import Foundation
import Alamofire

protocol ResponseHandlerDelegate {
    func handleResponse(response: Response<AnyObject, NSError>)
}