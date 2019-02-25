//
//  InfoTableViewCell.swift
//  网络传值
//
//  Created by USER on 2019/02/22.
//  Copyright © 2019 ZZL. All rights reserved.
//

import UIKit

class InfoTableViewCell: UITableViewCell {

    @IBOutlet weak var shuxing: UILabel!
    @IBOutlet weak var data: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
