//
//  SingleStudent.swift
//  网络传值
//
//  Created by USER on 2019/02/24.
//  Copyright © 2019 ZZL. All rights reserved.
//

import Foundation


//学生信息一览内，单个学生的类型

struct SingleStudent:Decodable {
    var s_no   :String?
    var name   :String?
    var grade  :String?
}
