//
//  HttpClient.swift
//  PushedActionableMessages
//
//  Created by Samuel Geno on 10/04/2016.
//  Copyright © 2016 Geno. All rights reserved.
//

import Foundation
import Alamofire

class HTTPClient {
    
    static let URL_BASE = "https://cheza.herokuapp.com/"
    static var parameters = [String: AnyObject]()
    static var headers = [
        "Content-Type": "application/json"
    ]
    
    
    class func post(service: String, var parameters:[String: AnyObject], responseHandlerDelegate: ResponseHandlerDelegate){
        
        print(URL_BASE+service.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!+"/")
        Alamofire.request(.POST, URL_BASE+service.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!+"/", parameters: parameters, encoding: .JSON, headers: headers).responseJSON { response in
            responseHandlerDelegate.handleResponse(response)
        }
    }
    
    
    class func get(service: String, var parameters:[String: AnyObject], responseHandlerDelegate: ResponseHandlerDelegate){
        Alamofire.request(.GET, URL_BASE+service+"/", parameters: parameters).responseJSON { response in
            responseHandlerDelegate.handleResponse(response)
        }
    }
    
    
}