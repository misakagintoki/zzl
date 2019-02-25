//
//  SingleStudentDetail.swift
//  网络传值
//
//  Created by USER on 2019/02/25.
//  Copyright © 2019 ZZL. All rights reserved.
//

import Foundation

struct SingleStudentDetail:Decodable {
    var s_no         :String?
    var name         :String?
    var grade        :String?
    var birthday     :String?
    var phone_number :String?
}

struct messageFromUrl:Decodable {
    var message:String?
}
