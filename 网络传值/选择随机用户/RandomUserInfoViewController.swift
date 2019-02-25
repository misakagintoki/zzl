//
//  RandomUserInfoViewController.swift
//  网络传值
//
//  Created by USER on 2019/02/22.
//  Copyright © 2019 ZZL. All rights reserved.
//

import UIKit

struct UserInfo {
    var name:String?
    var gender:String?
    var email:String?
    var avatarUrl:String?
    
}

class RandomUserInfoViewController: UIViewController {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var infoTableView: UITableView!
    
    var address = "https://randomuser.me/api/"
    //从网上取值，必先建立副线程，步骤：建立session，给session赋值
    var session:URLSession?
    
    //建立一个变量，一个符合结构体属性的可选类型，作为cell生成时取值所用
    var singleInfo:UserInfo?
    
    
    //为了防备连续点击手势互动，超过了网络传输的速度d，从而导致出bug的事态，需要做好防御措施
    var isloading = false      // false的时候允许下载，true的时候不能下载
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoTableView.delegate = self
        infoTableView.dataSource = self
        
        session = URLSession(configuration: .default)
        
        singleInfo = UserInfo()
        
        let tapEvent = UITapGestureRecognizer(target: self, action: #selector(changeUser))
        avatarImageView.addGestureRecognizer(tapEvent)
        avatarImageView.isUserInteractionEnabled = true
        
        downloadInfo()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //如果想要变更图像的外形，需要重写viewdidlayoutsubviews
        //理由，程序生成，先运行viewDidload，后运行 viewDidLayouSubviews，所以如果放在viewDidLoad时没效果的
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
        avatarImageView.layer.masksToBounds = true
    }
    
    @objc func changeUser(){
        if !isloading{
            downloadInfo()
        }
    }
    
    func downloadInfo(){
        if let url = URL(string: address){
            let task = session?.dataTask(with: url, completionHandler: {
                (data,response,error) in
                if error != nil{
                    print(error!.localizedDescription)
                    self.isloading = false
                    return
                }
                if let downloadData = data{
                    // let resultData = JSONDecoder().decode(<#T##type: Decodable.Protocol##Decodable.Protocol#>, from: Data) 让resultData等于，转换成符合decodable这个协议的结构体的Data，但因为是throw，所以有风险，所以要使用do catch结构写法
                    do{
                        let resultData = try JSONDecoder().decode(DownloadData.self, from: downloadData)
                        print(resultData)
                        let firstName = resultData.results?[0].name?.first
                        let lastName = resultData.results?[0].name?.last
                        let fullName:String? = {   //这是一个闭包，用到了guard else 的闭包
                            //guard let 弱化版的if let ，如果guard let后面能够成功赋值，那就成功赋值，不然就直接结束
                            guard let realFirstName = firstName, let realLastName = lastName else {return nil}
                            return realFirstName + " " + realLastName
                        }()
                        self.singleInfo?.name = fullName
                        self.singleInfo?.email = resultData.results?[0].email
                        self.singleInfo?.gender = resultData.results?[0].gender
                        if let realUrl = resultData.results?[0].picture?.large{
                            self.downloadImage(url: realUrl)
                        }
                        DispatchQueue.main.async(execute: {
                            self.infoTableView.reloadData()
                        })
                    }catch{
                        print(error.localizedDescription)
                        self.isloading = false
                        return
                    }
                }
                
                
                
                
                //下面的这种写法是将每一个数据单独拆包的写法，暂时注释掉
                //                if let downloadData = data {
                //                    do {
                //                        //options只要设置一个数组即可，表示可以容纳多种数据
                //                        let json = try JSONSerialization.jsonObject(with: downloadData, options: [])
                //                        //                        print(json)
                //                        self.parseJson(downloadInfo: json)
                //                        DispatchQueue.main.async(execute: {
                //                            self.infoTableView.reloadData()
                //                        })
                //                    } catch {
                //                        print(error.localizedDescription)
                //                    }
                //                }
                
            })
            task?.resume()   //前面都是定义task，这个时候才是任务开始，主线程继续往下走，把isloading变成了true，而副线程跑去执行task了
            isloading = true
        }
    }
    
    func parseJson(downloadInfo:Any?){
        if let json = downloadInfo as? [String:Any]{
            if let infoArray = json["results"] as? [[String:Any]]{
                print(infoArray)
                let infoDict = infoArray[0]
                print(infoDict)
                singleInfo?.email = infoDict["email"] as? String
                singleInfo?.gender = infoDict["gender"] as? String
                
                //因为名字的数据较为复杂，所以需要多一层的拆包
                if let name = infoDict["name"] as? [String:String]{
                    let firstName = name["first"] ?? ""
                    let lastName = name["last"] ?? ""
                    singleInfo?.name = firstName + " " + lastName
                }
                
                //图片也是一样
                if let singlePicture = infoDict["picture"] as? [String:String]{
                    if let imageUrl = singlePicture["large"]{
                        downloadImage(url: imageUrl)
                    }
                }
            }
        }
    }
    
    func downloadImage(url:String){
        if let imageUrl = URL(string: url){
            let task = session?.dataTask(with: imageUrl, completionHandler: {
                //data 下载的任务。response 页面请求的错误 error页面通信失败的错误
                (data,response,error) in
                if error != nil{
                    print(error!.localizedDescription)
                    self.isloading = false
                    return //切记，如果进入了这个错误的线路，必须要用return来中断代码
                }
                if let downloadData = data{
                    let downloadData = UIImage(data: downloadData)
                    //因为session处理的办法本来就是在副线程里面运行，所以需要回到主线程
                    DispatchQueue.main.async {
                        self.avatarImageView.image = downloadData
                        self.isloading = false
                    }
                }
            })
            task?.resume() // 之前只是定义好了这个任务，但是还没有确定执行，现在才是真正的执行任务
        }
        
    }
    
}

extension RandomUserInfoViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as! InfoTableViewCell
        switch indexPath.row {
        case 0:
            cell.shuxing.text = "姓名"
            cell.data.text = singleInfo?.name
        case 1:
            cell.shuxing.text = "性别"
            cell.data.text = singleInfo?.gender
        case 2:
            cell.shuxing.text = "email"
            cell.data.text = singleInfo?.email
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
