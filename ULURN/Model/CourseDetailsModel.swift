//
//  CourseDetailsModel.swift
//  ULURN
//
//  Created by Rakesh Chakraborty on 16/06/24.
//

import Foundation
import Alamofire

// MARK: - CourseDetailsModel
struct CourseDetailsModel: Codable {
    let isSuccess: Bool?
    let message: String?
    let responseData: String?
    
    enum CodingKeys: String, CodingKey {
        case isSuccess = "IsSuccess"
        case message = "Message"
        case responseData = "responseObj"
    }
}

// MARK: - LoginResponseData
struct SectionDetailsData: Codable {
    let sectionId: Int?
    let sectionName: String?
    var collapsed: Bool?
    let chapters: [ChapterDetailsData]
    enum CodingKeys: String, CodingKey {
        case sectionId = "code"
        case sectionName = "name"
        case collapsed = "collapsed"
        case chapters = "items"
    }
}

struct ChapterDetailsData: Codable {
    let chapterId: Int?
    let chapterName: String?
    enum CodingKeys: String, CodingKey {
        case chapterId = "code"
        case chapterName = "name"
    }
}

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
    func responseCourseDetailsModel(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<CourseDetailsModel>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
