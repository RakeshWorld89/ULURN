//
//  CourseDetailsViewController.swift
//  ULURN
//
//  Created by Rakesh Chakraborty on 20/05/24.
//

import UIKit
import MBProgressHUD

class CourseDetailsViewController: UIViewController {
    
    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var courseDetailsTableView: UITableView!
    
    var courseNameSelected: String?
    var courseIdSelected: Int?
    //var courseModules = courseModuleData
    var courseModules: [SectionDetailsData] = []
    var courseModuleName: String?
    var activityIndicatorView: MBProgressHUD!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        courseNameLabel.text = courseNameSelected
        self.courseDetailsTableView.register(UINib(nibName: "CourseModuleTableViewHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "CourseModuleTableViewHeader")
        self.courseDetailsTableView.register(UINib(nibName: "CourseModuleDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "CourseModuleDetailsTableViewCell")
        self.courseDetailsTableView.rowHeight = UITableView.automaticDimension
        self.courseDetailsTableView.tableFooterView = nil
        
        self.activityIndicatorView = showIndicator(withTitle: "", and: "Loading Chapters...")
        self.view.isUserInteractionEnabled = false
        AppCommon.triggerLatestTokenWebService() { (isTokenGenerated) in
            if isTokenGenerated == true {
                self.loadAllCourseSectionsAndItsChapters()
            } else {
                
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Show the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        //self.navigationController?.navigationBar.topItem?.title = courseNameSelected
        self.navigationController?.navigationBar.backItem?.title = ""
        self.courseDetailsTableView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    
    func loadAllCourseSectionsAndItsChapters() {
        ApiManager.fetchAllSectionsAndChapters(userId: UserDefaults.standard.value(forKey: Constants.LOGGED_IN_USER_ID) as! Int, productId: courseIdSelected!) { [weak self] response, error in
            self?.activityIndicatorView.hide(animated: true)
            if response?.isSuccess == true {
                let courseDetailsData = (response?.responseData ?? "").data(using: .utf8)
                let courseDetailsDecoder = JSONDecoder()
                if let courseDetailsModel = try? courseDetailsDecoder.decode([SectionDetailsData].self, from: courseDetailsData!) {
                    print(courseDetailsModel)
                    self?.courseModules = courseDetailsModel
                    self?.courseDetailsTableView.reloadData()
                }
            } else {
                let errorMessage = (response?.responseData)?.components(separatedBy: ":")
                AppCommon.showAlert(title: Constants.UNKNOWN_ERROR_TITLE, message: errorMessage?[1] ?? "")
            }
            self?.view.isUserInteractionEnabled = true
        }
    }
    
    
    @IBAction func tapRefreshCourseDetailsButtonAction(_ sender: Any) {
        
    }
}

extension CourseDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return courseModules.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courseModules[section].collapsed! ? 0 : courseModules[section].chapters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseModuleDetailsTableViewCell", for: indexPath) as! CourseModuleDetailsTableViewCell
        
        let chapter: ChapterDetailsData = courseModules[indexPath.section].chapters[indexPath.row]
        let sectionNumberPrefix = courseModules[indexPath.section].sectionId
        let chapterNumberPrefix = "\(sectionNumberPrefix ?? 0)" + ".\(indexPath.row + 1) -> "
        cell.courseModuleDetailNameLabel.text = "\(chapterNumberPrefix)" + chapter.chapterName!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedChapterCell = tableView.cellForRow(at: indexPath) as! CourseModuleDetailsTableViewCell
        
        let chapterDetailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChapterDetailsViewController") as! ChapterDetailsViewController
        chapterDetailsVC.courseAndModuleName = courseModules[indexPath.section].sectionName
        chapterDetailsVC.chapterName = selectedChapterCell.courseModuleDetailNameLabel.text
        chapterDetailsVC.chapterId = courseModules[indexPath.section].chapters[indexPath.row].chapterId
        self.navigationController?.pushViewController(chapterDetailsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // Header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CourseModuleTableViewHeader") as! CourseModuleTableViewHeader
        header.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapCourseModuleHeader(_:))))
        
        header.courseModuleNameLabel.text = courseModules[section].sectionName
        //self.courseModuleName = header.courseModuleNameLabel.text
        header.codeNumberLabel.text = "\(courseModules[section].sectionId ?? 0)"
        header.setCollapsed(courseModules[section].collapsed!)
        
        header.section = section
        header.delegate = self
        
        return header
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 120.0
//    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    @objc func tapCourseModuleHeader(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let headerView = gestureRecognizer.view as? CourseModuleTableViewHeader else {
            return
        }
        headerView.delegate?.toggleSection(headerView, section: headerView.section)
    }
}

extension CourseDetailsViewController: CourseModuleTableViewHeaderDelegate {
    
    func toggleSection(_ header: CourseModuleTableViewHeader, section: Int) {
        
        let sectionCollapsed = !courseModules[section].collapsed!
        // Toggle collapse
        courseModules[section].collapsed = sectionCollapsed
        header.setCollapsed(sectionCollapsed)
        
        self.courseDetailsTableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
    }
}
