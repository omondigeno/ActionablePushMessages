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
    static var headers = [
        "Content-Type": "application/json"
    ]
    
    /**
     Sends an HTTP POST request
     
     - Parameters:
     - service: identifies the service to consume
     - parameters: holds the request payload/parameters
     - responseHandlerDelegate: an object that handles reponses
     
     */
    class func post(service: String, parameters:[String: AnyObject], responseHandlerDelegate: ResponseHandlerDelegate){
        
        print(URL_BASE+service.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!+"/")
        Alamofire.request(.POST, URL_BASE+service.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!+"/", parameters: parameters, encoding: .JSON, headers: headers).responseJSON { response in
            responseHandlerDelegate.handleResponse(response)
        }
    }
    
    /**
     Sends an HTTP GET request
     
     - Parameters:
     - service: identifies the service to consume
     - parameters: holds the request payload/parameters
     - responseHandlerDelegate: an object that handles reponses
     
     */
    class func get(service: String, parameters:[String: AnyObject], responseHandlerDelegate: ResponseHandlerDelegate){
        Alamofire.request(.GET, URL_BASE+service+"/", parameters: parameters).responseJSON { response in
            responseHandlerDelegate.handleResponse(response)
        }
    }
    
    
}