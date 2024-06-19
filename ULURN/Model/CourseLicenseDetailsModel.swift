//
//  CourseLicenseDetailsModel.swift
//  ULURN
//
//  Created by Rakesh Chakraborty on 10/06/24.
//

import Foundation
import Alamofire

// MARK: - CourseLicenseDetailsModel
struct CourseLicenseDetailsModel: Codable {
    let isSuccess: Bool?
    let message: String?
    let responseData: String?
    
    enum CodingKeys: String, CodingKey {
        case isSuccess = "IsSuccess"
        case message = "Message"
        case responseData = "responseObj"
    }
}

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseLoginResponseData { response in
//     if let loginResponseData = response.result.value {
//       ...
//     }
//   }


// MARK: - LoginResponseData
struct CourseLicenseDetailsData: Codable {
    let userId, productId, lectureCount: Int?
    let uniqueId, productName, productAuthor: String?
    enum CodingKeys: String, CodingKey {
        case userId = "U"
        case productId = "Z"
        case lectureCount = "LC"
        case uniqueId = "I"
        case productName = "ZN"
        case productAuthor = "ZA"
    }
}

// MARK: - Alamofire response handlers

extension DataRequest {
    fileprivate func decodableResponseSerializer<T: Decodable>() -> DataResponseSerializer<T> {
        return DataResponseSerializer { _, response, data, error in
            guard error == nil else { return .failure(error!) }

            guard let data = data else {
                return .failure(AFError.responseSerializationFailed(reason: .inputDataNil))
            }
            return Result { try newJSONDecoder().decode(T.self, from: data) }
        }
    }

    @discardableResult
    fileprivate func responseDecodable<T: Decodable>(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        return response(queue: queue, responseSerializer: decodableResponseSerializer(), completionHandler: completionHandler)
    }

    @discardableResult
    func responseCourseLicenseDetailsModel(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<CourseLicenseDetailsModel>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
