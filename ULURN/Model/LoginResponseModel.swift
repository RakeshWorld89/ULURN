//
//  LoginResponseModel.swift
//  ULURN
//
//  Created by Rakesh Chakraborty on 04/06/24.
//

import Foundation
import Alamofire

// MARK: - LoginResponseModel
struct LoginResponseModel: Codable {
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
struct LoginResponseData: Codable {
    let userId: Int?
    let email, firstName, lastName, mobileNumber: String?
    enum CodingKeys: String, CodingKey {
        case userId = "I"
        case email = "E"
        case firstName = "N"
        case lastName = "L"
        case mobileNumber = "T"
    }
}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
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
    func responseLoginResponseModel(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<LoginResponseModel>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
