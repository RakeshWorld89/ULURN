//
//  MyCoursesViewController.swift
//  ULURN
//
//  Created by Rakesh Chakraborty on 19/05/24.
//

import UIKit
import MBProgressHUD

class MyCoursesViewController: UIViewController {
    
    @IBOutlet weak var myCoursesCountLabel: UILabel!
    @IBOutlet weak var myCoursesTableView: UITableView!
    
    var myCoursesData: [CourseLicense] = []
    var activityIndicatorView: MBProgressHUD!
    var selectedCourseProductId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.myCoursesTableView.register(UINib(nibName: "MyCourseTableViewCell", bundle: nil), forCellReuseIdentifier: "MyCourseTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        AppCommon.triggerLatestTokenWebService() { (isTokenGenerated) in
            if isTokenGenerated == true {
                self.fetchAllCourses()
            } else {
                
            }
        }
    }

    func fetchAllCourses() {
        if CoreDataManager.sharedManager.fetchAllCourses(userId: UserDefaults.standard.value(forKey: Constants.LOGGED_IN_USER_ID) as! Int)!.count > 0 {
            activityIndicatorView = showIndicator(withTitle: "", and: "")
            self.checkForAnyNewCourses()
        }
    }
    
    func checkForAnyNewCourses() {
        ApiManager.fetchAllCourseLicenseDetails(userId: UserDefaults.standard.value(forKey: Constants.LOGGED_IN_USER_ID) as! Int, serviceType: Constants.getAllNewCourseLicenseDetails) { [weak self] response, error in
            self?.activityIndicatorView.hide(animated: true)
            if response?.isSuccess == true {
                let courseLicenseDetailsData = (response?.responseData ?? "").data(using: .utf8)
                let courseLicenseDetailsDecoder = JSONDecoder()
                if let courseLicenseDetailsModel = try? courseLicenseDetailsDecoder.decode([CourseLicenseDetailsData].self, from: courseLicenseDetailsData!) {
                    print(courseLicenseDetailsModel)
                    
                    if courseLicenseDetailsModel.count > 0 {
                        self?.saveNewCourseDetailsInDatabase(courseLicenseDetailsModel: courseLicenseDetailsModel)
                    } else {
                        self?.myCoursesData = CoreDataManager.sharedManager.fetchAllCourses(userId: UserDefaults.standard.value(forKey: Constants.LOGGED_IN_USER_ID) as! Int) ?? []
                        self?.myCoursesCountLabel.text = "My Courses(\(self?.myCoursesData.count ?? 0))"
                        self?.myCoursesTableView.reloadData()
                    }
                }
            } else {
                let errorMessage = (response?.responseData)?.components(separatedBy: ":")
                AppCommon.showAlert(title: Constants.UNKNOWN_ERROR_TITLE, message: errorMessage?[2] ?? "")
            }
        }
    }
    
    func saveNewCourseDetailsInDatabase(courseLicenseDetailsModel: [CourseLicenseDetailsData]) {
        for index in 0..<(courseLicenseDetailsModel.count - 1) {
            CoreDataManager.sharedManager.insertCourseLicenseDetails(courseLicenseDetails: courseLicenseDetailsModel[index])
        }
        self.myCoursesData = CoreDataManager.sharedManager.fetchAllCourses(userId: UserDefaults.standard.value(forKey: Constants.LOGGED_IN_USER_ID) as! Int) ?? []
        self.myCoursesCountLabel.text = "My Courses(\(self.myCoursesData.count))"
        self.myCoursesTableView.reloadData()
    }
    
    @IBAction func tapHiddenCoursesAction(_ sender: Any) {
        
    }
    
    @IBAction func tapRefreshCoursesAction(_ sender: Any) {
        
    }
}

extension MyCoursesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myCoursesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCourseTableViewCell", for: indexPath) as! MyCourseTableViewCell
        cell.courseNameLabel.text = myCoursesData[indexPath.row].productName
        cell.lecturesCountLabel.text = "\(myCoursesData[indexPath.row].lectureCount)" + " Registered Courses"
        cell.lecturerNameLabel.text = myCoursesData[indexPath.row].productAuthor
        return cell
    }   
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCourseCell = tableView.cellForRow(at: indexPath) as! MyCourseTableViewCell
        selectedCourseProductId = Int(myCoursesData[indexPath.row].productId)
        UserDefaults.standard.set(selectedCourseProductId, forKey: Constants.PRODUCT_ID)
        activityIndicatorView = showIndicator(withTitle: "", and: "")
        AppCommon.triggerLatestTokenWebService() { (isTokenGenerated) in
            if isTokenGenerated == true {
                self.checkForCourseValidity(productId: self.selectedCourseProductId) { (isCourseValid) in
                    if isCourseValid == true {
                        let courseDetailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CourseDetailsViewController") as! CourseDetailsViewController
                        courseDetailsVC.courseNameSelected = selectedCourseCell.courseNameLabel.text
                        courseDetailsVC.courseIdSelected = self.selectedCourseProductId
                        self.navigationController?.pushViewController(courseDetailsVC, animated: true)
                    }
                }
            } else {
                
            }
        }
    }
    
    func checkForCourseValidity(productId: Int, completion: @escaping(Bool)->()){
        
        ApiManager.checkValidityOfCourse(userId: UserDefaults.standard.value(forKey: Constants.LOGGED_IN_USER_ID) as! Int, productId: selectedCourseProductId) { [weak self] response, error in
            self?.activityIndicatorView.hide(animated: true)
            if response?.isSuccess == true {
                if response?.responseData == "true" {
                    completion(true)
                } else {
                    completion(false)
                    let errorMessage = (response?.responseData)?.components(separatedBy: ":")
                    AppCommon.showAlert(title: Constants.UNKNOWN_ERROR_TITLE, message: errorMessage?[1] ?? "")
                }
            }
            else {
                completion(false)
                let errorMessage = (response?.responseData)?.components(separatedBy: ":")
                AppCommon.showAlert(title: Constants.UNKNOWN_ERROR_TITLE, message: errorMessage?[1] ?? "")
            }
        }
    }
}
