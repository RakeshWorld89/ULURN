//
//  CreateTokenModel.swift
//  ULURN
//
//  Created by Rakesh Chakraborty on 04/06/24.
//

import Foundation
import Alamofire

// MARK: - LoginResponseModel
struct CreateTokenResponseModel: Codable {
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
    func responseCreateTokenResponseModel(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<CreateTokenResponseModel>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
