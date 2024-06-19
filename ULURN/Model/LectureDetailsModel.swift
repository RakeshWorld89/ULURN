//
//  LectureDetailsModel.swift
//  ULURN
//
//  Created by Rakesh Chakraborty on 19/06/24.
//

import Foundation
import Alamofire

// MARK: - LectureDetailsModel
struct LectureDetailsModel: Codable {
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


// MARK: - LectureDetailsData
struct LectureDetailsData: Codable {
    let serialNumber, uniqueId, productId, sectionId, chapterId: Int?
    let lectureName: String?
    let lectureDuration: Double?
    enum CodingKeys: String, CodingKey {
        case serialNumber = "SR"
        case uniqueId = "I"
        case productId = "P"
        case sectionId = "Z"
        case chapterId = "S"
        case lectureName = "LN"
        case lectureDuration = "D"
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
    func responseLectureDetailsModel(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<LectureDetailsModel>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
