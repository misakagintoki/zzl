//
//  StudentInfoViewController.swift
//  网络传值
//
//  Created by USER on 2019/02/24.
//  Copyright © 2019 ZZL. All rights reserved.
//

import UIKit

enum PostType {
    case GetAll
    case GetSingle
}

var host = "http://www.kinwork.jp:7775/LearnApi"

class StudentInfoViewController: UIViewController {
    
    
    @IBOutlet weak var listTableView: UITableView!
    
    var studentList:[SingleStudent] = []
    //建立一个变量，用来存API的地址（HOST），有时候很多地方都要通信，而host只有一个的时候，可以考虑做成全局变量
//    var host = "http://www.kinwork.jp:7775/LearnApi"
    var postUrl_getAll = "/getStudentList"
    var postUrl_getStu = "/viewStudent"
    
    var session:URLSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listTableView.delegate = self
        listTableView.dataSource = self
        
        session = URLSession(configuration: .default)
        
        //进行获得学生一览的通信
        let strUrl = host + postUrl_getAll
        getData(strUrl: strUrl,type: .GetAll, para: nil)
    }
    
    func getData(strUrl:String,type:PostType,para:[String:String]?){
        //        let strUrl = host + postUrl_getAll
        if let url = URL(string: strUrl){
            var urlRequest = URLRequest(url: url)
            
            let list = NSMutableArray() //可变数组
            //如果有para才会进入下面这一段代码，改变，完成请求，否则，就直接进入后面的代码
            if para != nil{
                //设置通信方式为post
                urlRequest.httpMethod = "POST"
                //整理post用的数据
                for(key,value) in para!{
                    let itemStr = "\(key)=\(value)"
                    list.add(itemStr)
                }
                let paraStr = list.componentsJoined(by: "&")
                let paraData = paraStr.data(using: String.Encoding.utf8)
                urlRequest.httpBody = paraData
            }
            
            
            let task = session?.dataTask(with: urlRequest, completionHandler: {
                (data,response,error) in
                if error != nil{
                    print(error!.localizedDescription)
                    return
                }
                if let downloadData = data{
                    do{
                        switch type{
                        case .GetAll:
                            self.studentList = try JSONDecoder().decode([SingleStudent].self, from: downloadData)
                            DispatchQueue.main.async(execute: {
                                self.listTableView.reloadData()
                            })
                        case .GetSingle:
                            let selectedStudent = try JSONDecoder().decode(SingleStudentDetail.self, from: downloadData)
//                            print(selectedStudent)
                            DispatchQueue.main.async(execute: {
                                self.performSegue(withIdentifier: "TotalInfoSegue", sender: selectedStudent)
                            })
                        }
                    }catch{
                        print(error.localizedDescription)
                    }
                }
            })
            task?.resume()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TotalInfoSegue"{
            let detailPage = segue.destination as! SingleStudentInfoViewController
            let singleStudentInfo = sender as! SingleStudentDetail
            detailPage.singleStudent = singleStudentInfo
        }
    }
    
    
    
}

extension StudentInfoViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath) as! StudentTableViewCell
        cell.singleStudent = studentList[indexPath.row]
        cell.setupData()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let studentNo = studentList[indexPath.row].s_no{
            let paraDict = ["s_no":studentNo]
            let strUrl = host + postUrl_getStu
            getData(strUrl: strUrl, type: .GetSingle, para: paraDict)
        }
    }
}
