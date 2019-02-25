//
//  StudentInfoViewController.swift
//  网络传值
//
//  Created by USER on 2019/02/24.
//  Copyright © 2019 ZZL. All rights reserved.
//

import UIKit

class StudentInfoViewController: UIViewController {

    
    @IBOutlet weak var listTableView: UITableView!
    
    var studentList:[SingleStudent] = []
    //建立一个变量，用来存API的地址（HOST），有时候很多地方都要通信，而host只有一个的时候，可以考虑做成全局变量
    var host = "http://www.kinwork.jp:7775/LearnApi"
    var postUrl_getAll = "/getStudentList"
    
    var session:URLSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        listTableView.delegate = self
        listTableView.dataSource = self
        
        session = URLSession(configuration: .default)
        
        getData()
    }

    func getData(){
        let strUrl = host + postUrl_getAll
        if let url = URL(string: strUrl){
            let urlRequest = URLRequest(url: url)
            let task = session?.dataTask(with: urlRequest, completionHandler: {
                (data,response,error) in
                if error != nil{
                    print(error!.localizedDescription)
                    return
                }
                if let downloadData = data{
                    do{
                        self.studentList = try JSONDecoder().decode([SingleStudent].self, from: downloadData)
                        DispatchQueue.main.async(execute: {
                            self.listTableView.reloadData()
                        })
                    }catch{
                        print(error.localizedDescription)
                    }
                }
            })
            task?.resume()
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
    
    
}
