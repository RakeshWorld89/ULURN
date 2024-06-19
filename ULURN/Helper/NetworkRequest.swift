//
//  NetworkRequest.swift
//  ULURN
//
//  Created by Rakesh Chakraborty on 02/06/24.
//

import Foundation
import Alamofire

class NetworkRequest {
    class func createRequest(httpMethod: String, tokenString: String? = nil, serviceType: String, parameter: [String : Any]?) -> URLRequest {
        if httpMethod == "POST" {
            var request = URLRequest(url: URL(string: Constants.OTHER_BASEURL)!)
            request.httpMethod = HTTPMethod.post.rawValue
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(tokenString, forHTTPHeaderField: "Authorization")
            request.setValue(serviceType, forHTTPHeaderField: "ServiceType")
            do { 
                let jsonData = try JSONSerialization.data(withJSONObject: parameter as Any, options: .prettyPrinted)
                request.httpBody = jsonData
            } catch { print(error.localizedDescription) }
            return request
        } else {
            return URLRequest(url: URL(string: "")!)
        }
    }
    
    class func createTokenRequest(httpMethod: String, serviceType: String, parameter: [String : Any]?) -> URLRequest {
        if httpMethod == "POST" {
            var request = URLRequest(url: URL(string: Constants.BASEURL_TOKEN)!)
            request.httpMethod = HTTPMethod.post.rawValue
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(serviceType, forHTTPHeaderField: "ServiceType")
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: parameter as Any, options: .prettyPrinted)
                request.httpBody = jsonData
            } catch { print(error.localizedDescription) }
            return request
        } else {
            return URLRequest(url: URL(string: "")!)
        }
    }
}
