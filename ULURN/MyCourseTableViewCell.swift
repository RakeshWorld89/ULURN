//
//  CourseDetailsTableViewCell.swift
//  ULURN
//
//  Created by Rakesh Chakraborty on 19/05/24.
//

import UIKit

class CourseDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var lecturesCountLabel: UILabel!
    @IBOutlet weak var lecturerNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func tapCourseDetailsAction(_ sender: Any) {
        
    }
    
    @IBAction func tapHideFromListAction(_ sender: Any) {
        
    }
}
