//
//  CourseDetailsViewController.swift
//  ULURN
//
//  Created by Rakesh Chakraborty on 20/05/24.
//

import UIKit

class CourseDetailsViewController: UIViewController {
    
    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var courseDetailsTableView: UITableView!
    
    var courseNameSelected: String?
    var courseModules = courseModuleData
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        courseNameLabel.text = courseNameSelected
        self.courseDetailsTableView.register(UINib(nibName: "CourseModuleTableViewHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "CourseModuleTableViewHeader")
        self.courseDetailsTableView.register(UINib(nibName: "CourseModuleDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "CourseModuleDetailsTableViewCell")
        self.courseDetailsTableView.rowHeight = UITableView.automaticDimension
        self.courseDetailsTableView.tableFooterView = nil
    }
    
    @IBAction func tapRefreshCourseDetailsButtonAction(_ sender: Any) {
        
    }
}

extension CourseDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return courseModules.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courseModules[section].collapsed ? 0 : courseModules[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseModuleDetailsTableViewCell", for: indexPath) as! CourseModuleDetailsTableViewCell
        
        let item: Item = courseModules[indexPath.section].items[indexPath.row]
        cell.courseModuleDetailNameLabel.text = item.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // Header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CourseModuleTableViewHeader") as! CourseModuleTableViewHeader
        header.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapCourseModuleHeader(_:))))
        
        header.courseModuleNameLabel.text = courseModules[section].name
        header.codeNumberLabel.text = courseModules[section].code
        header.setCollapsed(courseModules[section].collapsed)
        
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
        
        let collapsed = !courseModules[section].collapsed
        // Toggle collapse
        courseModules[section].collapsed = collapsed
        header.setCollapsed(collapsed)
        
        self.courseDetailsTableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
    }
}
