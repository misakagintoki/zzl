//
//  Userinfo.swift
//  网络传值
//
//  Created by USER on 2019/02/24.
//  Copyright © 2019 ZZL. All rights reserved.
//


//由于从api下载来的数据大多非常繁杂，如果需要用到的数据少的话还好处理，不过如果考虑到大数据调用，一个一个拆包就太蠢了，这个时候，就应该根据API的数据类型，建立结构体，把整个数据保存下来，以便以后使用
import Foundation

//有时候，会发现结构体里面有些属性也是自己定义的结构体，所以就会出现结构体里面出现结构体的现象
//重点：每一个结构体都必须遵循Decodable这个协议
struct  DownloadData:Decodable {
    var results:[SingleData]?
}


//要注意，每一个命名都必须跟下载下来的data的Key相同，不然就找不到数据了
//没有必要把下载下来的所有数据都拆包，只需要建立自己需要的变量即可
struct SingleData:Decodable {
    var gender:String?
    var name:NameData?
    var email:String?
    var picture:PictureData?
}

struct NameData:Decodable {
    var first:String?
    var last:String?
}

struct PictureData:Decodable {
    var large:String?
}
