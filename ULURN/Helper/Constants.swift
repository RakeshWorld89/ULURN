//
//  Constants.swift
//  ULURN
//
//  Created by Rakesh Chakraborty on 02/06/24.
//

import Foundation
import UIKit

struct Constants {
    //MARK: - BASE URL -
    static let BASEURL = "https://ulurnapis.ulurn.in/testenvironment"
    static let BASEURL_TOKEN = "https://dzm2821gnl.execute-api.ap-south-1.amazonaws.com/token" //"https://token.ulurn.in/prod-create-token"
    static let OTHER_BASEURL = "https://5is83791al.execute-api.ap-south-1.amazonaws.com/stage"
    static let IMAGE_BASE_URL = ""
    
    //MARK: - Error Messages -
    static let UNKNOWN_ERROR_TITLE = "ERROR"
    static let UNKNOWN_ERROR_MESSAGE = "An unknown error occured. Please try again later."
    
    //MARK: - TOKEN GENERATION EMAIL & PASSWORD -
    static let emailIdForToken = "offlinedemo@gmail.com"
    static let passwordForToken = "23K74y1OHxKw1SsI"
    
    //MARK: - Webservice Types -
    static let createToken = "CreateToken"
    static let login = "Login"
    static let appVersion = "ServerStatus"
    static let userProduct = "UserProduct"
    static let productDetails = "Product"
    static let getAllCourseLicenseDetails = "UserAllCourseLicense"
    static let getAllNewCourseLicenseDetails = "UserCourseLicense"
    static let checkCourseValidity = "IsCourseValidityExpired"
    static let getAllSectionsAndChapters = "ProductSectionWithTopic"
    static let getAllProductLectures = "ProductLectures"
    static let lectureDetails = "LectureDetail"
    static let getProfile = ""
    static let getFAQs = ""
    
    //MARK: - User Defaults Key Names -
    static let TOKEN_STRING = "tokenString"
    static let LOGGED_IN_USER_ID = "userId"
    static let LOGGED_IN_EMAIL_ID = "emailId"
    static let LOGGED_IN_USERNAME = "fullUserName"
    static let MOBILE_NUMBER = "mobileNumber"
    static let PRODUCT_ID = "courseId"
    static let IS_DARK_MODE = ""
    static let USER_PROFILE_IMAGE = "user_profile_image"
}
