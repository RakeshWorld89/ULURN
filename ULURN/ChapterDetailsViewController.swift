//
//  ChapterDetailsViewController.swift
//  ULURN
//
//  Created by Rakesh Chakraborty on 25/05/24.
//

import UIKit
import MBProgressHUD

class ChapterDetailsViewController: UIViewController {
 
    @IBOutlet weak var courseAndModuleNameLabel: UILabel!
    @IBOutlet weak var chapterNameLabel: UILabel!
    @IBOutlet weak var lectureVideosTableView: UITableView!
    @IBOutlet weak var noLecturesAvailableView: UIView!
    
    var courseAndModuleName: String?
    var chapterName: String?
    var chapterId: Int?
    var activityIndicatorView: MBProgressHUD!
    var allLecturesData: [Lecture] = []
    var selectedLectureId: Int = 0
    var generatedLectureVideoURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.courseAndModuleNameLabel.text = courseAndModuleName
        self.chapterNameLabel.text = chapterName
        self.lectureVideosTableView.register(UINib(nibName: "LectureVideoTableViewCell", bundle: nil), forCellReuseIdentifier: "LectureVideoTableViewCell")
        
        activityIndicatorView = showIndicator(withTitle: "", and: "Loading Lectures...")
        AppCommon.triggerLatestTokenWebService() { (isTokenGenerated) in
            if isTokenGenerated == true {
                self.fetchAllProductLectures()
            } else {
                
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Show the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.navigationBar.backItem?.title = ""
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    
    func fetchAllProductLectures() {
        
        ApiManager.fetchAllLectureDetails(chapterId: self.chapterId ?? 0, lastLectureId: 0) { [weak self] response, error in
            self?.activityIndicatorView.hide(animated: true)
            if response?.isSuccess == true {
                let lectureDetailsData = (response?.responseData ?? "").data(using: .utf8)
                let lectureDetailsDecoder = JSONDecoder()
                if let lectureDetailsModel = try? lectureDetailsDecoder.decode([LectureDetailsData].self, from: lectureDetailsData!) {
                    print(lectureDetailsModel)
                    
                    if lectureDetailsModel.count > 0 {
                        self?.noLecturesAvailableView.isHidden = true
                        self?.saveLectureDetailsInDatabase(lectureDetailsModel: lectureDetailsModel)
                    } else {
                        self?.noLecturesAvailableView.isHidden = false
                    }
                }
            } else {
                let errorMessage = (response?.responseData)?.components(separatedBy: ":")
                AppCommon.showAlert(title: Constants.UNKNOWN_ERROR_TITLE, message: errorMessage?[1] ?? "")
            }
        }
    }
    
    func saveLectureDetailsInDatabase(lectureDetailsModel: [LectureDetailsData]) {
        if CoreDataManager.sharedManager.fetchAllLectures(chapterId: self.chapterId ?? 0)?.count == 0 {
            for index in 0..<(lectureDetailsModel.count) {
                CoreDataManager.sharedManager.insertLectureDetails(lectureDetails: lectureDetailsModel[index])
            }
        }
        self.allLecturesData = CoreDataManager.sharedManager.fetchAllLectures(chapterId: self.chapterId ?? 0) ?? []
        self.lectureVideosTableView.reloadData()
    }
}

extension ChapterDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allLecturesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LectureVideoTableViewCell", for: indexPath) as! LectureVideoTableViewCell
        cell.lectureVideoNameLabel.text = self.allLecturesData[indexPath.row].lectureName
        cell.lectureVideoDurationLabel.text = self.allLecturesData[indexPath.row].duration.secondsToVideoTime()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedLectureVideoCell = tableView.cellForRow(at: indexPath) as! LectureVideoTableViewCell
        selectedLectureId = Int(self.allLecturesData[indexPath.row].lectureUniqueId)

        activityIndicatorView = showIndicator(withTitle: "", and: "Loading...")
        AppCommon.triggerLatestTokenWebService() { (isTokenGenerated) in
            if isTokenGenerated == true {
                self.loadLectureURLFromServer()
            } else {
                
            }
        }
    }
    
    func loadLectureURLFromServer() {
        ApiManager.fetchLectureURL(userId: UserDefaults.standard.value(forKey: Constants.LOGGED_IN_USER_ID) as! Int, productId: UserDefaults.standard.value(forKey: Constants.PRODUCT_ID) as! Int, lectureId: self.selectedLectureId) { [weak self] response, error in
            self?.activityIndicatorView.hide(animated: true)
            if response?.isSuccess == true {
                let lectureURLDetailsData = (response?.responseData ?? "").data(using: .utf8)
                let lectureURLDetailsDecoder = JSONDecoder()
                if let lectureURLDetailsModel = try? lectureURLDetailsDecoder.decode(LectureURLDetailsData.self, from: lectureURLDetailsData!) {
                    print(lectureURLDetailsModel)
                    self?.generatedLectureVideoURL = lectureURLDetailsModel.finalURL
                    
                    self?.moveToPlayerScreen()
                }
            } else {
                let errorMessage = (response?.responseData)?.components(separatedBy: ":")
                AppCommon.showAlert(title: Constants.UNKNOWN_ERROR_TITLE, message: errorMessage?[1] ?? "")
            }
        }
    }
    
    func moveToPlayerScreen() {
        let lectureVideoPlayerController = LectureVideoPlayerViewController()
        lectureVideoPlayerController.lectureURL = self.generatedLectureVideoURL
        present(lectureVideoPlayerController, animated: true)
    }
}
