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

class ResponseHandler: ResponseHandlerDelegate {
    
    var background: Bool
    weak var viewController: UIViewController?
    
    init(background: Bool, viewController: UIViewController?){
        self.background = background
        self.viewController = viewController
    }
    
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
    func handleResponse(response: JSON) {
        showMessageHideProgress(getResponseMessage(response))
    }
    func handleAPIerror(response: JSON) {
        showMessageHideProgress(getResponseMessage(response))
    }
    func getResponseMessage(response: JSON) -> String? {
        var msg: String?
        if let responseMesage = response["status_message"].asString {
            return responseMesage;
        }else{
            return Utils.getString("network_error_internal_error")
        }
    }
    
    func showMessageHideProgress(message: String?){
        if !background && viewController != nil{
            Common.hideProgress(viewController!)
            if message != nil{
                Common.showMessage(message!, viewController: viewController!)
            }
        }
        print(message)
    }
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