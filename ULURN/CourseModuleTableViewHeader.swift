//
//  CourseModuleTableViewHeader.swift
//  ULURN
//
//  Created by Rakesh Chakraborty on 20/05/24.
//

import UIKit

protocol CourseModuleTableViewHeaderDelegate {
    func toggleSection(_ header: CourseModuleTableViewHeader, section: Int)
}

class CourseModuleTableViewHeader: UITableViewHeaderFooterView {
    
    var delegate: CourseModuleTableViewHeaderDelegate?
    var section: Int = 0
    
    @IBOutlet weak var courseModuleNameLabel: UILabel!
    @IBOutlet weak var codeNumberLabel: UILabel!
    @IBOutlet weak var plusMinusSignImageView: UIImageView!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    // Trigger toggle section when tapping on the header
    func setCollapsed(_ collapsed: Bool) {
        if collapsed {
            plusMinusSignImageView.image = UIImage(named: "PlusSign")
        } else {
            plusMinusSignImageView.image = UIImage(named: "MinusSign")
        }
    }
}
