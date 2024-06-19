//
//  LectureVideoTableViewCell.swift
//  ULURN
//
//  Created by Rakesh Chakraborty on 25/05/24.
//

import UIKit

class LectureVideoTableViewCell: UITableViewCell {

    @IBOutlet weak var lectureVideoNameLabel: UILabel!
    @IBOutlet weak var lectureVideoDurationLabel: UILabel!
    @IBOutlet weak var lectureThumbnailImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
