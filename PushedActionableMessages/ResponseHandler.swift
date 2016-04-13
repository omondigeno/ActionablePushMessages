//
//  ResponseHandler.swift
//  PushedActionableMessages
//
//  Created by Samuel Geno on 10/04/2016.
//  Copyright © 2016 Geno. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

/// Handles responses for http requests
class ResponseHandler: ResponseHandlerDelegate {
    
    var background: Bool
    weak var viewController: UIViewController?
    
    /**
     Initializes a new response handler
     
     - Parameters:
     - background: tells us whether the request is done in the background without user knowing or otherwise
     - viewController: The view controller currently presented
     
     */
    init(background: Bool, viewController: UIViewController?){
        self.background = background
        self.viewController = viewController
    }
    
    /**
     Called to handle response
     
     - Parameters:
     - response: the object with the response status and data
     
     */
    func handleResponse(response: Response<AnyObject, NSError>){
        
        if(response.response?.statusCode == HTTPStatusCode.OK.rawValue){
            if let jsonObj = response.result.value {
                let json = JSON(jsonObj)
                print(json)
                
                if let responseStatus = json["status_code"].asInt where responseStatus == 1 {
                    handleResponse(json)
                }else{
                    handleAPIerror(json)
                }
                
            }
            
        }else{
            handleHTTPerror(response.response)
        }
        
    }
    /**
     Called to handle successful response
     
     - Parameters:
     - response: the JSON object with the response data
     
     */
    func handleResponse(response: JSON) {
        showMessageHideProgress(getResponseMessage(response))
    }
    
    /**
     Called to handle non http errors in response
     
     - Parameters:
     - response: the JSON object with the response data
     
     */
    func handleAPIerror(response: JSON) {
        showMessageHideProgress(getResponseMessage(response))
    }
    
    /**
     Called to get response message
     
     - Parameters:
     - response: the JSON object with the response data
     
     - Returns: status message or internal error message if status message was not available
     
     */
    
    func getResponseMessage(response: JSON) -> String? {
        if let responseMesage = response["status_message"].asString {
            return responseMesage;
        }else{
            return Utils.getString("network_error_internal_error")
        }
    }
    
    /**
     Shows response message and hides progress if request was not in the background
     
     - Parameters:
     - response: the response message
     
     */
    func showMessageHideProgress(message: String?){
        if !background && viewController != nil{
            Common.hideProgress(viewController!)
            if message != nil{
                Common.showMessage(message!, viewController: viewController!)
            }
        }
        print(message)
    }
    
    /**
     Handles HTTP status error codes
     
     - Parameters:
     - response: the NSHTTPURLResponse object
     
     */
    func handleHTTPerror(response: NSHTTPURLResponse?){
        var msg: String = ""
        switch response?.statusCode {
        case  .Some(HTTPStatusCode.BadRequest.rawValue):
            msg = Utils.getString("network_error_bad_request")
        case .Some(HTTPStatusCode.Unauthorized.rawValue), .Some(HTTPStatusCode.Forbidden.rawValue):
            msg = Utils.getString("network_error_unauthorized")
        case .Some(HTTPStatusCode.NotFound.rawValue), .Some(HTTPStatusCode.Gone.rawValue):
            msg = Utils.getString("network_error_not_found")
        case .Some(HTTPStatusCode.RequestTimeout.rawValue), .Some(HTTPStatusCode.GatewayTimeout.rawValue):
            msg = Utils.getString("network_error_time_out")
        case .Some(HTTPStatusCode.InternalServerError.rawValue):
            msg = Utils.getString("network_error_internal_error")
        case .Some(HTTPStatusCode.ServiceUnavailable.rawValue):
            msg = Utils.getString("network_error_unavailable")
        default:
            msg = Utils.getString("network_error_msg")
        }
        showMessageHideProgress(msg)
    }
    
    
}