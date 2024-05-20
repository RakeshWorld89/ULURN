//
//  MyCoursesViewController.swift
//  ULURN
//
//  Created by Rakesh Chakraborty on 19/05/24.
//

import UIKit

class MyCoursesViewController: UIViewController {
    
    @IBOutlet weak var myCoursesCountLabel: UILabel!
    @IBOutlet weak var myCoursesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.myCoursesTableView.register(UINib(nibName: "MyCourseTableViewCell", bundle: nil), forCellReuseIdentifier: "MyCourseTableViewCell")
    }
    
    @IBAction func tapHiddenCoursesAction(_ sender: Any) {
        
    }
    
    @IBAction func tapRefreshCoursesAction(_ sender: Any) {
        
    }
}

extension MyCoursesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCourseTableViewCell", for: indexPath) as! MyCourseTableViewCell
        return cell
    }   
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCourseCell = tableView.cellForRow(at: indexPath) as! MyCourseTableViewCell
        let courseDetailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CourseDetailsViewController") as! CourseDetailsViewController
        courseDetailsVC.courseNameSelected = selectedCourseCell.courseNameLabel.text
        self.navigationController?.pushViewController(courseDetailsVC, animated: true)
    }
}
