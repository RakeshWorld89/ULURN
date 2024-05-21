//
//  ViewController.swift
//  ULURN
//
//  Created by Rakesh Chakraborty on 17/05/24.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var mainContentView: UIView!
    @IBOutlet weak var userNameView: UIView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        if textField == self.userNameTextField {
            UserDefaults.standard.setValue(textField.text, forKey: "username")
        }
        textField.resignFirstResponder()
    }
}

