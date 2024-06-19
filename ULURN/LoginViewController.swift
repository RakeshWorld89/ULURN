//
//  ViewController.swift
//  ULURN
//
//  Created by Rakesh Chakraborty on 17/05/24.
//

import UIKit
import MBProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var mainContentView: UIView!
    @IBOutlet weak var userNameView: UIView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton! {
        didSet {
            signInButton.roundCorners([.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 12.0)
        }
    }
    
    
    var activityIndicatorView: MBProgressHUD!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        userNameTextField.text = "89rchakraborty@gmail.com"
        passwordTextField.text = "1234567890"
    }
    
    override func viewWillLayoutSubviews() {
        mainContentView.roundCorners([.topLeft, .topRight], radius: 12)
        userNameView.roundCorners([.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 25.0)
        passwordView.roundCorners([.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 25.0)
    }
}

extension LoginViewController {
    
    @IBAction func tapForgotPasswordAction(_ sender: Any) {
        
    }
    
    @IBAction func tapNeedHelpAction(_ sender: Any) {
        
    }
    
    @IBAction func tapSignInAction(_ sender: Any) {
        activityIndicatorView = showIndicator(withTitle: "", and: "Logging in...")
        AppCommon.triggerLatestTokenWebService() { (isTokenGenerated) in
            if isTokenGenerated == true {
                self.triggerSignInWebService()
            } else {
                
            }
        }
    }
    
    func triggerSignInWebService() {
        guard let uuid = UIDevice.current.identifierForVendor?.uuidString else {
            print("Unable to retrieve device ID.")
            self.activityIndicatorView.hide(animated: true)
            AppCommon.showAlert(title: Constants.UNKNOWN_ERROR_TITLE, message: "Unable to retrieve device ID.")
            return
        }
        print("Device ID: \(uuid)")
        
        ApiManager.loginULURN(userEmailId: self.userNameTextField.text ?? "", password: self.passwordTextField.text ?? "", deviceId: uuid, deviceType: "true") { [weak self] response, error in
            if response?.isSuccess == true {
                UserDefaults.standard.setValue(self?.userNameTextField.text ?? "", forKey: Constants.LOGGED_IN_EMAIL_ID)
                let loginResponseData = (response?.responseData ?? "").data(using: .utf8)
                let loginResponseDecoder = JSONDecoder()
                if let loginResponseModel = try? loginResponseDecoder.decode(LoginResponseData.self, from: loginResponseData!) {
                    print(loginResponseModel)
                    
                    let fullUserName = (loginResponseModel.firstName ?? "") + " " + (loginResponseModel.lastName ?? "")
                    UserDefaults.standard.setValue(fullUserName, forKey: Constants.LOGGED_IN_USERNAME)
                    UserDefaults.standard.setValue(loginResponseModel.userId, forKey: Constants.LOGGED_IN_USER_ID)
                    UserDefaults.standard.setValue(loginResponseModel.email ?? "", forKey: Constants.LOGGED_IN_EMAIL_ID)
                    UserDefaults.standard.setValue(loginResponseModel.mobileNumber, forKey: Constants.MOBILE_NUMBER)
                }
                self?.activityIndicatorView.detailsLabel.text = "Fetching Courses..."
                self?.triggerUserLicenseDetailsWebService()
                
            } else {
                let errorMessage = (response?.responseData)?.components(separatedBy: ":")
                AppCommon.showAlert(title: Constants.UNKNOWN_ERROR_TITLE, message: errorMessage?[2] ?? "")
            }
        }
    }
    
    func triggerUserLicenseDetailsWebService() {
        
        ApiManager.fetchAllCourseLicenseDetails(userId: UserDefaults.standard.value(forKey: Constants.LOGGED_IN_USER_ID) as! Int, serviceType: Constants.getAllCourseLicenseDetails) { [weak self] response, error in
            self?.activityIndicatorView.hide(animated: true)
            if response?.isSuccess == true {
                let courseLicenseDetailsData = (response?.responseData ?? "").data(using: .utf8)
                let courseLicenseDetailsDecoder = JSONDecoder()
                if let courseLicenseDetailsModel = try? courseLicenseDetailsDecoder.decode([CourseLicenseDetailsData].self, from: courseLicenseDetailsData!) {
                    print(courseLicenseDetailsModel)
                    
                    self?.saveCourseDetailsInDatabase(courseLicenseDetailsModel: courseLicenseDetailsModel)
                }
            } else {
                let errorMessage = (response?.responseData)?.components(separatedBy: ":")
                AppCommon.showAlert(title: Constants.UNKNOWN_ERROR_TITLE, message: errorMessage?[2] ?? "")
            }
        }
    }
    
    func saveCourseDetailsInDatabase(courseLicenseDetailsModel: [CourseLicenseDetailsData]) {
        if CoreDataManager.sharedManager.fetchAllCourses(userId: UserDefaults.standard.value(forKey: Constants.LOGGED_IN_USER_ID) as! Int)?.count == 0 {
            for index in 0..<(courseLicenseDetailsModel.count) {
                CoreDataManager.sharedManager.insertCourseLicenseDetails(courseLicenseDetails: courseLicenseDetailsModel[index])
            }
        }
        self.moveToHomeScreen()
    }
    
    func moveToHomeScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
        // This is to get the SceneDelegate object from your view controller
        // then call the change root view controller function to change to main tab bar
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
    }
    
    @IBAction func tapKnowMoreAction(_ sender: Any) {
        
    }
    
    @IBAction func tapQueriesAction(_ sender: Any) {
        
    }
    
    @IBAction func tapFAQsAction(_ sender: Any) {
        
    }
    
    @IBAction func tapRegisterAction(_ sender: Any) {
        
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
}

