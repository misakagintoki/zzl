//
//  MainViewController.swift
//  网络传值
//
//  Created by USER on 2019/02/22.
//  Copyright © 2019 ZZL. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var testImageView: UIImageView!
    
    var session:URLSession?
    
    
    let webUrl = "https://08.imgmini.eastday.com/mobile/20180511/0db7711c17a6a06f039f21ec3624cd73_wmk.jpeg"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        session = URLSession(configuration: .default) //在画面展开的时候，不允许调用构造函数
        
        if let imageUrl = URL(string: webUrl){
            let task = session?.downloadTask(with: imageUrl, completionHandler: {
                (url,response,error) in
                if error != nil{
                    let errCode = (error! as NSError).code
                    if errCode == -1009{
                        let alertView = UIAlertController(title: "网络连接失败", message: "", preferredStyle: .alert)
                        self.present(alertView, animated: true, completion: {
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                alertView.dismiss(animated: true, completion: nil)
                            }
                        })
                        
                    }else{
                        print(error!.localizedDescription)
                    }
                    
                    return
                }
                if let downloakUrl = url{
                    do{
                        let downloadData = try Data(contentsOf: downloakUrl)
                        let downloadImage = UIImage(data: downloadData)
                        DispatchQueue.main.async {
                            self.testImageView.image = downloadImage
                        }
                    }catch{
                        print(error.localizedDescription)
                    }
                    
                }
            })
            task?.resume()
        }
        
        
        
        
        
//        
//                if let imageUrl = URL(string: webUrl){
//                    let task = session?.dataTask(with: imageUrl, completionHandler: {
//                        //data 下载的任务。response 页面请求的错误 error页面通信失败的错误
//                        (data,response,error) in
//                        if error != nil{
//                            print(error!.localizedDescription)
//                            return //切记，如果进入了这个错误的线路，必须要用return来中断代码
//                        }
//                        if let downloadData = data{
//                            let downloadData = UIImage(data: downloadData)
//                            //因为session处理的办法本来就是在副线程里面运行，所以需要回到主线程
//                            DispatchQueue.main.async {
//                                self.testImageView.image = downloadData
//                            }
//                        }
//                    })
//                    task?.resume() // 之前只是定义好了这个任务，但是还没有确定执行，现在才是真正的执行任务
//                }
        
        //throws 指存在错误的可能性,代码有风险，需要把有风险的代码放进do catch结构里面，且在风险代码前加入一个try（do-catch结构，do里面的代码出现异常的话，就会执行catch里面的代码）
        //        if let imageUrl = URL(string: webUrl){
        //            //建立一个线程，执行一下任务
        //            DispatchQueue.global().async(execute: {
        //                do {
        //                    //把花时间的，从网上提取资料的任务在副线程里面实现
        //                    let downloadImage = UIImage(data: try Data.init(contentsOf: imageUrl))
        //                    //实现完成后返回主线程，执行核心代码，展示图片
        //                    DispatchQueue.main.async(execute: {
        //                        self.testImageView.image = downloadImage
        //                    })
        //
        //                    //下面这一段和上面的是一个效果，理由：这是一个闭包，第四步，如果这是最后一个参数的值，可以放在（）外面，参数名字删掉，第五步，如果这是唯一的一个参数，则可以把（）删掉
        ////                    DispatchQueue.main.async {
        ////                        self.testImageView.image = downloadImage
        ////                    }
        //                    //任务结束
        //
        //                } catch{
        //                    //如果任务出现异常，报告给程序员
        //                    print(error.localizedDescription)
        //                }})
        
        
        //            do {
        //                //从网上拿到图片的地址（结尾为.jpg .jepg）把它转换为data格式，再作为标志，建立图片
        //                //但是这样写其实是有问题的，因为如果下载太花时间，则程序响应缓慢，应把它挪进副线程
        //                testImageView.image = UIImage(data: try Data.init(contentsOf: imageUrl))
        //            } catch{
        //                print(error.localizedDescription)
        //            }
        
        
    }
}



