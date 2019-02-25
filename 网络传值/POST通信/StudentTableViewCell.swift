//
//  StudentTableViewCell.swift
//  网络传值
//
//  Created by USER on 2019/02/24.
//  Copyright © 2019 ZZL. All rights reserved.
//

import UIKit

class StudentTableViewCell: UITableViewCell {

    @IBOutlet weak var studentNameLabel: UILabel!
    @IBOutlet weak var studentGradeLabel: UILabel!
    
    var singleStudent:SingleStudent?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func setupData(){
        studentNameLabel.text = singleStudent?.name
        studentGradeLabel.text = singleStudent?.grade
    }
}
