//
//  StudentInfoViewController.swift
//  网络传值
//
//  Created by USER on 2019/02/24.
//  Copyright © 2019 ZZL. All rights reserved.
//

import UIKit

class StudentInfoViewController: ParentViewController {
    
    
    @IBOutlet weak var listTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listTableView.delegate = self
        listTableView.dataSource = self
        
        //app开始运行的时候，进行获得学生一览的通信
//        reloadTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadTableView()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TotalInfoSegue"{
            let detailPage = segue.destination as! SingleStudentInfoViewController
            let singleStudentInfo = sender as! SingleStudentDetail
            detailPage.singleStudent = singleStudentInfo
        }
    }
    
    func reloadTableView(){
        let strUrl = host + postUrl_getAll
        let postClass = PostClass()
        postClass.reloadTableView = self
        postClass.getData(strUrl: strUrl, type: .GetAll, para: nil)
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
            let postClass = PostClass()
            postClass.reloadTableView = self
            postClass.getData(strUrl: strUrl, type: .GetSingle, para: paraDict)
        }
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if let studentNo = studentList[indexPath.row].s_no{
            let paraDict = ["s_no":studentNo]
            let strUrl = host + postUrl_deleStu
            
            //重中之重，要使用协议，必须实例化协议，且让它在本页面实现
            let postClass = PostClass()
            postClass.reloadTableView = self
            
            //建立一个警告视图，建立一个公共类，作出一个警告视图的建立函数，以用于继承
            let cancelAction = UIAlertAction(title: "我知道了", style: .default, handler: nil)
            let alertController = doAlert(title: "成功删除", message: "已经把这个学生的资料从服务器删除", okAction: nil, cancelAction: cancelAction, style: .alert)

            //在删除键里面调价方法，从数据上删除数据后，弹出这个警告视图
            let deleteStu = UITableViewRowAction(style: .normal, title: "删除") { (action, indexPath) in
                //从服务器上面删除学生信息，更新tableview的代码应该写在方法里，不然的话，会先更新tableviw后删除数据
                postClass.getData(strUrl: strUrl, type: .deleStu, para: paraDict)
                //在本地数据中删除该行的学生信息
                studentList.remove(at: indexPath.row)
                //跳出警告视图，提示已经删除
                self.present(alertController, animated: true, completion: nil)
            }
            
            deleteStu.backgroundColor = .red
            return [deleteStu]
        }
        return nil
    }
    
    
    
}

//协议的方法，1.跳转画面，2.刷新tableView
extension StudentInfoViewController: ReloadtableView{
    func perfrom(selected:Any) {
        performSegue(withIdentifier: "TotalInfoSegue", sender: selected)
    }
    
    func reload() {
        listTableView.reloadData()
    }
    
}
