//
//  AppCommon.swift
//  ULURN
//
//  Created by Rakesh Chakraborty on 05/06/24.
//

import Foundation
import UIKit

class AppCommon {
    
    //MARK: - Show Alert -
    class func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let sceneDelegate = UIApplication.shared.connectedScenes
                .first!.delegate as! SceneDelegate
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default) { UIAlertAction in
            }
            alertController.addAction(okAction)
            sceneDelegate.window?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    class func triggerLatestTokenWebService(completion: @escaping(Bool)->()) {
        ApiManager.getToken() { response, error in
            if response?.isSuccess == true {
                UserDefaults.standard.setValue((response?.responseData ?? "") as String, forKey: Constants.TOKEN_STRING)
                completion(true)
            } else {
                completion(false)
                self.showAlert(title: Constants.UNKNOWN_ERROR_TITLE, message: Constants.UNKNOWN_ERROR_MESSAGE)
            }
        }
    }
    
    static func stringify(json: Any, prettyPrinted: Bool = false) -> String {
        var options: JSONSerialization.WritingOptions = []
        if prettyPrinted {
          options = JSONSerialization.WritingOptions.prettyPrinted
        }

        do {
          let data = try JSONSerialization.data(withJSONObject: json, options: options)
          if let string = String(data: data, encoding: String.Encoding.utf8) {
            return string
          }
        } catch {
          print(error)
        }

        return ""
    }
    
    static func stringToJsonObject(jsonString: String) -> Any {
        do{
            if let json = jsonString.data(using: String.Encoding.utf8){
                if let jsonData = try JSONSerialization.jsonObject(with: json, options: .allowFragments) as? [String:AnyObject] {
                    return jsonData
                }
            }
        }catch {
            print(error.localizedDescription)
            return [:]
        }
        return [:]
    }
}
