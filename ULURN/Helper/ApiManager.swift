//
//  ApiManager.swift
//  ULURN
//
//  Created by Rakesh Chakraborty on 04/06/24.
//

import Foundation
import Alamofire

struct ApiError: Error {
    enum ErrorType: String {
        case api = "ApiError"
        case system = "SystemError"
    }
    let domain: ErrorType
    let code: Int
    let message: String
}

class ApiManager {
    
    // MARK: Get Token Service
    class func getToken(completion: @escaping(_ response: CreateTokenResponseModel?, _ error: ApiError?) -> Void) {
        
        let parameters = ["userName": Constants.emailIdForToken, "password": Constants.passwordForToken] as [String : Any]
        let parametersAsJsonData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        let parametersAsJsonString = String(data: parametersAsJsonData!, encoding: .utf8)
        
        let requestBody = ["body": parametersAsJsonString ?? "", "headers": ["ServiceType": Constants.createToken]] as [String : Any]
        print(AppCommon.stringify(json: requestBody))
        let request = NetworkRequest.createTokenRequest(httpMethod: HTTPMethod.post.rawValue, serviceType: Constants.createToken, parameter: requestBody)
        Alamofire.request(request)
            .responseCreateTokenResponseModel { (response) in
                switch response.result {
                case .success(let result):
                    if result.isSuccess == true {
                        completion(result, nil);
                    } else {
                        completion(result, ApiError(domain: .api, code: response.response?.statusCode ?? 0, message: ""))
                    }
                case .failure(let error):
                    completion(nil, ApiError(domain: .system, code: error._code, message: error.localizedDescription))
                }
            } .responseString { (response) in
                print(response.result.value ?? "No Response")
            }
    }
    
    // MARK: Login Service
    
    class func loginULURN(userEmailId: String, password: String, deviceId: String, deviceType: String, completion: @escaping(_ reponse: LoginResponseModel?, _ error: ApiError?) -> Void) {
        
        let parameters = ["userName": userEmailId, "password": password, "deviceId": deviceId, "deviceType": deviceType] as [String : Any]
        let parametersAsJsonData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        let parametersAsJsonString = String(data: parametersAsJsonData!, encoding: .utf8)
        
        let requestBody = ["body": parametersAsJsonString ?? "", "headers": ["ServiceType": Constants.login]] as [String: Any]
        let request = NetworkRequest.createRequest(httpMethod: HTTPMethod.post.rawValue, tokenString: UserDefaults.standard.string(forKey: Constants.TOKEN_STRING)!, serviceType: Constants.login, parameter: requestBody)
        Alamofire.request(request)
            .responseLoginResponseModel { (response) in
                switch response.result {
                case .success(let result):
                    if result.isSuccess == true {
                        completion(result, nil);
                    } else {
                        completion(result, ApiError(domain: .api, code: response.response?.statusCode ?? 0, message: ""))
                    }
                case .failure(let error):
                    completion(nil, ApiError(domain: .system, code: error._code, message: error.localizedDescription))
                }
            } .responseString { (response) in
                print(response.result.value ?? "No Response")
            }
    }
    
    // MARK: All Course License Service
    
    class func fetchAllCourseLicenseDetails(userId: Int, serviceType: String, completion: @escaping(_ reponse: CourseLicenseDetailsModel?, _ error: ApiError?) -> Void) {
        
        let parameters = ["userId": userId] as [String : Any]
        let parametersAsJsonData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        let parametersAsJsonString = String(data: parametersAsJsonData!, encoding: .utf8)
        
        let requestBody = ["body": parametersAsJsonString ?? "", "headers": ["ServiceType": serviceType]] as [String: Any]
        let request = NetworkRequest.createRequest(httpMethod: HTTPMethod.post.rawValue, tokenString: UserDefaults.standard.string(forKey: Constants.TOKEN_STRING)!, serviceType: serviceType, parameter: requestBody)
        Alamofire.request(request)
            .responseCourseLicenseDetailsModel { (response) in
                switch response.result {
                case .success(let result):
                    if result.isSuccess == true {
                        completion(result, nil);
                    } else {
                        completion(result, ApiError(domain: .api, code: response.response?.statusCode ?? 0, message: ""))
                    }
                case .failure(let error):
                    completion(nil, ApiError(domain: .system, code: error._code, message: error.localizedDescription))
                }
            } .responseString { (response) in
                print(response.result.value ?? "No Response")
            }
    }
    
    // MARK: Course Validity Service
    
    class func checkValidityOfCourse(userId: Int, productId: Int, completion: @escaping(_ reponse: CourseValidityModel?, _ error: ApiError?) -> Void) {
        
        let parameters = ["userId": userId, "productId": productId] as [String : Any]
        let parametersAsJsonData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        let parametersAsJsonString = String(data: parametersAsJsonData!, encoding: .utf8)
        
        let requestBody = ["body": parametersAsJsonString ?? "", "headers": ["ServiceType": Constants.checkCourseValidity]] as [String: Any]
        let request = NetworkRequest.createRequest(httpMethod: HTTPMethod.post.rawValue, tokenString: UserDefaults.standard.string(forKey: Constants.TOKEN_STRING)!, serviceType: Constants.checkCourseValidity, parameter: requestBody)
        Alamofire.request(request)
            .responseCourseValidityModel { (response) in
                switch response.result {
                case .success(let result):
                    if result.isSuccess == true {
                        completion(result, nil);
                    } else {
                        completion(result, ApiError(domain: .api, code: response.response?.statusCode ?? 0, message: ""))
                    }
                case .failure(let error):
                    completion(nil, ApiError(domain: .system, code: error._code, message: error.localizedDescription))
                }
            } .responseString { (response) in
                print(response.result.value ?? "No Response")
            }
    }
    
    // MARK: All Sections and Chapters Service
    
    class func fetchAllSectionsAndChapters(userId: Int, productId: Int, completion: @escaping(_ reponse: CourseDetailsModel?, _ error: ApiError?) -> Void) {
        
        let parameters = ["userId": userId, "productId": productId] as [String : Any]
        let parametersAsJsonData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        let parametersAsJsonString = String(data: parametersAsJsonData!, encoding: .utf8)
        
        let requestBody = ["body": parametersAsJsonString ?? "", "headers": ["ServiceType": Constants.getAllSectionsAndChapters]] as [String: Any]
        let request = NetworkRequest.createRequest(httpMethod: HTTPMethod.post.rawValue, tokenString: UserDefaults.standard.string(forKey: Constants.TOKEN_STRING)!, serviceType: Constants.getAllSectionsAndChapters, parameter: requestBody)
        Alamofire.request(request)
            .responseCourseDetailsModel { (response) in
                switch response.result {
                case .success(let result):
                    if result.isSuccess == true {
                        completion(result, nil);
                    } else {
                        completion(result, ApiError(domain: .api, code: response.response?.statusCode ?? 0, message: ""))
                    }
                case .failure(let error):
                    completion(nil, ApiError(domain: .system, code: error._code, message: error.localizedDescription))
                }
            } .responseString { (response) in
                print(response.result.value ?? "No Response")
            }
    }
    
    // MARK: All Lectures Service
    
    class func fetchAllLectureDetails(chapterId: Int, lastLectureId: Int? = nil, completion: @escaping(_ reponse: LectureDetailsModel?, _ error: ApiError?) -> Void) {
        
        let parameters = ["productId": UserDefaults.standard.integer(forKey: Constants.PRODUCT_ID), "chapterId": chapterId, "lastLectureId": lastLectureId ?? 0] as [String : Any]
        let parametersAsJsonData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        let parametersAsJsonString = String(data: parametersAsJsonData!, encoding: .utf8)
        
        let requestBody = ["body": parametersAsJsonString ?? "", "headers": ["ServiceType": Constants.getAllProductLectures]] as [String: Any]
        let request = NetworkRequest.createRequest(httpMethod: HTTPMethod.post.rawValue, tokenString: UserDefaults.standard.string(forKey: Constants.TOKEN_STRING)!, serviceType: Constants.getAllProductLectures, parameter: requestBody)
        Alamofire.request(request)
            .responseLectureDetailsModel { (response) in
                switch response.result {
                case .success(let result):
                    if result.isSuccess == true {
                        completion(result, nil);
                    } else {
                        completion(result, ApiError(domain: .api, code: response.response?.statusCode ?? 0, message: ""))
                    }
                case .failure(let error):
                    completion(nil, ApiError(domain: .system, code: error._code, message: error.localizedDescription))
                }
            } .responseString { (response) in
                print(response.result.value ?? "No Response")
            }
    }
    
    // MARK: Lecture URL Service
    
    class func fetchLectureURL(userId: Int, productId: Int, lectureId: Int, completion: @escaping(_ reponse: CourseDetailsModel?, _ error: ApiError?) -> Void) {
        
        let parameters = ["userId": userId, "productId": productId, "lectureId": lectureId, "isMp4Play": false] as [String : Any]
        let parametersAsJsonData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        let parametersAsJsonString = String(data: parametersAsJsonData!, encoding: .utf8)
        
        let requestBody = ["body": parametersAsJsonString ?? "", "headers": ["ServiceType": Constants.lectureDetails]] as [String: Any]
        let request = NetworkRequest.createRequest(httpMethod: HTTPMethod.post.rawValue, tokenString: UserDefaults.standard.string(forKey: Constants.TOKEN_STRING)!, serviceType: Constants.lectureDetails, parameter: requestBody)
        Alamofire.request(request)
            .responseCourseDetailsModel { (response) in
                switch response.result {
                case .success(let result):
                    if result.isSuccess == true {
                        completion(result, nil);
                    } else {
                        completion(result, ApiError(domain: .api, code: response.response?.statusCode ?? 0, message: ""))
                    }
                case .failure(let error):
                    completion(nil, ApiError(domain: .system, code: error._code, message: error.localizedDescription))
                }
            } .responseString { (response) in
                print(response.result.value ?? "No Response")
            }
    }
    
    // MARK: Lecture History With Remaining Duration
    
    class func uploadLectureHistoryWithRemainingDuration(userId: Int, productId: Int, lectureId: Int, remainDuration: Double, lectureRemainDuration: Int, playTime: Int, completion: @escaping(_ reponse: LectureHistoryDetailsModel?, _ error: ApiError?) -> Void) {
     
        let parameters = ["userId": userId, "productId": productId, "lectureId": lectureId, "remainDuration": remainDuration, "lectureRemainDuration": lectureRemainDuration, "playTime": playTime] as [String : Any]
        let parametersAsJsonData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        let parametersAsJsonString = String(data: parametersAsJsonData!, encoding: .utf8)
        
        let requestBody = ["body": parametersAsJsonString ?? "", "headers": ["ServiceType": Constants.saveLecturePlayHistory]] as [String: Any]
        let request = NetworkRequest.createRequest(httpMethod: HTTPMethod.post.rawValue, tokenString: UserDefaults.standard.string(forKey: Constants.TOKEN_STRING)!, serviceType: Constants.saveLecturePlayHistory, parameter: requestBody)
        Alamofire.request(request)
            .responseLectureHistoryDetailsModel { (response) in
                switch response.result {
                case .success(let result):
                    if result.isSuccess == true {
                        completion(result, nil);
                    } else {
                        completion(result, ApiError(domain: .api, code: response.response?.statusCode ?? 0, message: ""))
                    }
                case .failure(let error):
                    completion(nil, ApiError(domain: .system, code: error._code, message: error.localizedDescription))
                }
            } .responseString { (response) in
                print(response.result.value ?? "No Response")
            }
    }
}
