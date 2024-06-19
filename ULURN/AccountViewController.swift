//
//  AccountViewController.swift
//  ULURN
//
//  Created by Rakesh Chakraborty on 21/05/24.
//

import UIKit

class AccountViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userPhoneLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userNameLabel.text = UserDefaults.standard.string(forKey: Constants.LOGGED_IN_USERNAME)
        userEmailLabel.text = UserDefaults.standard.string(forKey: Constants.LOGGED_IN_EMAIL_ID)
        userPhoneLabel.text = UserDefaults.standard.string(forKey: Constants.MOBILE_NUMBER)
        
        // Do any additional setup after loading the view.
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let barButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logOutButtonTapped(_:)))
        self.navigationItem.rightBarButtonItem = barButtonItem
    }
    
    @objc func logOutButtonTapped(_ sender: UIBarButtonItem) {
        UserDefaults.standard.removeObject(forKey: Constants.LOGGED_IN_EMAIL_ID)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginNavController = storyboard.instantiateViewController(identifier: "LoginNavigationController")
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
