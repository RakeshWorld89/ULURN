//
//  ChapterDetailsViewController.swift
//  ULURN
//
//  Created by Rakesh Chakraborty on 25/05/24.
//

import UIKit
import MBProgressHUD

protocol LastLectureHistoryDetails {
    func workWithLastLectureHistoryDetails(lectureHistory: [String : Any])
}

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
    var durationOfSelectedLecture: Double = 0.0
    var isLecturePlayed: Bool = false
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.courseAndModuleNameLabel.text = courseAndModuleName
        self.chapterNameLabel.text = chapterName
        self.lectureVideosTableView.register(UINib(nibName: "LectureVideoTableViewCell", bundle: nil), forCellReuseIdentifier: "LectureVideoTableViewCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Show the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.navigationBar.backItem?.title = ""
        self.appDelegate.orientation = .portrait
        //UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        DeviceOrientation.shared.set(orientation: .portrait)

        fetchAllProductLectures()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    
    func fetchAllProductLectures() {
        self.view.isUserInteractionEnabled = false
        if CoreDataManager.sharedManager.fetchAllLectures(chapterId: self.chapterId ?? 0)?.count == 0 {
            activityIndicatorView = showIndicator(withTitle: "", and: "Loading Lectures...")
            loadAllProductLectures()
        } else {
            if self.isLecturePlayed == false {
                activityIndicatorView = showIndicator(withTitle: "", and: "Refreshing Lectures...")
                self.noLecturesAvailableView.isHidden = true
                checkForAnyNewProductLectures()
            }
        }        
    }
    
    func loadAllProductLectures() {
        AppCommon.triggerLatestTokenWebService() { (isTokenGenerated) in
            if isTokenGenerated == true {
                ApiManager.fetchAllLectureDetails(chapterId: self.chapterId ?? 0) { [weak self] response, error in
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
                    self?.view.isUserInteractionEnabled = true
                }
            } else {
                
            }
        }
    }
    
    func checkForAnyNewProductLectures() {
        let lastLectureId = CoreDataManager.sharedManager.fetchLastLectureId(chapterId: self.chapterId ?? 0)
        AppCommon.triggerLatestTokenWebService() { (isTokenGenerated) in
            if isTokenGenerated == true {
                ApiManager.fetchAllLectureDetails(chapterId: self.chapterId ?? 0, lastLectureId: lastLectureId) { [weak self] response, error in
                    self?.activityIndicatorView.hide(animated: true)
                    if response?.isSuccess == true {
                        let lectureDetailsData = (response?.responseData ?? "").data(using: .utf8)
                        let lectureDetailsDecoder = JSONDecoder()
                        if let lectureDetailsModel = try? lectureDetailsDecoder.decode([LectureDetailsData].self, from: lectureDetailsData!) {
                            print(lectureDetailsModel)
                            
                            if lectureDetailsModel.count > 0 {
                                self?.saveLectureDetailsInDatabase(lectureDetailsModel: lectureDetailsModel)
                            } else {
                                self?.allLecturesData = CoreDataManager.sharedManager.fetchAllLectures(chapterId: self?.chapterId ?? 0) ?? []
                                self?.lectureVideosTableView.reloadData()
                            }
                        }
                    } else {
                        let errorMessage = (response?.responseData)?.components(separatedBy: ":")
                        AppCommon.showAlert(title: Constants.UNKNOWN_ERROR_TITLE, message: errorMessage?[1] ?? "")
                    }
                    self?.view.isUserInteractionEnabled = true
                }
            } else {
                
            }
        }
    }
    
    func saveLectureDetailsInDatabase(lectureDetailsModel: [LectureDetailsData]) {
        for index in 0..<(lectureDetailsModel.count) {
            CoreDataManager.sharedManager.insertLectureDetails(lectureDetails: lectureDetailsModel[index])
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
        
        _ = tableView.cellForRow(at: indexPath) as! LectureVideoTableViewCell
        selectedLectureId = Int(self.allLecturesData[indexPath.row].lectureUniqueId)
        durationOfSelectedLecture = self.allLecturesData[indexPath.row].duration
        
        self.view.isUserInteractionEnabled = false
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
                    if lectureURLDetailsModel.remainingDuration ?? 0.0 > 0.0 {
                        self?.moveToPlayerScreen(remainingTimeDuration: lectureURLDetailsModel.remainingDuration ?? 0.0, totalLectureDuration: self?.durationOfSelectedLecture ?? 0.0)
                    } else {
                        AppCommon.showAlert(title: Constants.UNKNOWN_ERROR_TITLE, message: Constants.LECTURE_PLAYER_ERROR_MESSAGE)
                    }
                }
            } else {
                let errorMessage = (response?.responseData)?.components(separatedBy: ":")
                AppCommon.showAlert(title: Constants.UNKNOWN_ERROR_TITLE, message: errorMessage?[1] ?? "")
            }
            self?.view.isUserInteractionEnabled = true
        }
    }
    
    func moveToPlayerScreen(remainingTimeDuration: Double, totalLectureDuration: Double) {
        let lectureVideoPlayerController = LectureVideoPlayerViewController()
        lectureVideoPlayerController.chapterDetailsVCDelegate = self
        lectureVideoPlayerController.lectureURL = self.generatedLectureVideoURL
        lectureVideoPlayerController.currentLectureId = self.selectedLectureId
        lectureVideoPlayerController.totalDuration = totalLectureDuration
        lectureVideoPlayerController.remainingDuration = remainingTimeDuration
        present(lectureVideoPlayerController, animated: true)
    }
}

extension ChapterDetailsViewController: LastLectureHistoryDetails {
    
    func workWithLastLectureHistoryDetails(lectureHistory: [String : Any]) {
        activityIndicatorView = showIndicator(withTitle: "", and: "Uploading Lecture History...")
        AppCommon.triggerLatestTokenWebService() { (isTokenGenerated) in
            if isTokenGenerated == true {
                ApiManager.uploadLectureHistoryWithRemainingDuration(userId: UserDefaults.standard.value(forKey: Constants.LOGGED_IN_USER_ID) as! Int, productId: UserDefaults.standard.value(forKey: Constants.PRODUCT_ID) as! Int, lectureId: self.selectedLectureId, remainDuration: lectureHistory["remainingDuration"] as! Double, lectureRemainDuration: lectureHistory["lectureRemainingDuration"] as! Int, playTime: lectureHistory["lecturePlayTime"] as! Int) { [weak self] response, error in
                    self?.activityIndicatorView.hide(animated: true)
                    if response?.isSuccess == true {
                        if response?.responseData == "true" {
                            AppCommon.showAlert(title: Constants.ULURN_APP, message: Constants.LECTURE_HISTORY_UPLOADED_MESSAGE)
                        } else {
                            AppCommon.showAlert(title: Constants.UNKNOWN_ERROR_TITLE, message: response?.responseData ?? Constants.UNKNOWN_ERROR_MESSAGE)
                        }
                    } else {
                        let errorMessage = (response?.responseData)?.components(separatedBy: ":")
                        AppCommon.showAlert(title: Constants.UNKNOWN_ERROR_TITLE, message: errorMessage?[1] ?? "")
                    }
                    self?.view.isUserInteractionEnabled = true
                }
            } else {
                
            }
        }
    }
}
