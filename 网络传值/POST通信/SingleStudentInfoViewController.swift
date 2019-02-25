//
//  SingleStudentInfoViewController.swift
//  网络传值
//
//  Created by USER on 2019/02/25.
//  Copyright © 2019 ZZL. All rights reserved.
//

import UIKit

let ScreenSize = UIScreen.main.bounds

class SingleStudentInfoViewController: UIViewController {
    
    
    @IBOutlet weak var inputNameTextField: UITextField!
    @IBOutlet weak var inputGradeTextField: UITextField!
    @IBOutlet weak var inputBirthTextField: UITextField!
    @IBOutlet weak var inoutPhoneTextField: UITextField!
    @IBOutlet weak var inputStudentNOTextField: UITextField!
    
    var get_updateStu = "/addStudent"
    
    var session:URLSession?
    
    //使用纯代码的方式，建立两个按键，一个叫做修改，一个叫做返回
    var changeButton:UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: ScreenSize.width / 4, y: 500, width: 50, height: 30)
        button.setTitle("修改", for: UIControl.State.normal)
        button.backgroundColor = UIColor.lightGray
        button.addTarget(self, action: #selector(changeInfo), for: .touchUpInside)
        return button
    }()
    
    var backButton:UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: (ScreenSize.width / 4) * 3 - 50, y: 500, width: 50, height: 30)
        button.setTitle("返回", for: UIControl.State.normal)
        button.backgroundColor = UIColor.lightGray
        button.addTarget(self, action: #selector(backToMain), for: .touchUpInside)
        return button
    }()
    
    
    var singleStudent:SingleStudentDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStudentInfo()
        
        self.view.addSubview(changeButton)
        self.view.addSubview(backButton)
        
        session = URLSession(configuration: .default)
    }
    
    func setStudentInfo(){
        inputNameTextField.text = singleStudent?.name
        inputGradeTextField.text = singleStudent?.grade
        inputBirthTextField.text = singleStudent?.birthday
        inoutPhoneTextField.text = singleStudent?.phone_number
    }
    
    @objc func backToMain(){
        dismiss(animated: true, completion: nil)
    }
    
    //建立按键，名为修改，如果textField上面的字没有被改变了，弹出警告视图，说没有改变，否则将改变后的数据上传到服务器
    @objc func changeInfo(){
        //只要有一个不相同，则表示被修改了
        if inputNameTextField.text != singleStudent?.name ||
            inputGradeTextField.text != singleStudent?.grade ||
            inputBirthTextField.text != singleStudent?.birthday ||
            inoutPhoneTextField.text != singleStudent?.phone_number{
            //如果被修改了，进行通信
            let strUrl = host + get_updateStu
            if let url = URL(string: strUrl){
                var urlRequest = URLRequest(url: url)
                
                let list = NSMutableArray() //可变数组
                //如果有para才会进入下面这一段代码，改变，完成请求，否则，就直接进入后面的代码
                let para = getKeyValue()
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
//                    print(urlRequest)
                }
                
                let task = session?.dataTask(with: urlRequest, completionHandler: {
                    (data,response,error) in
                    if error != nil{
                        print(error!.localizedDescription)
                        return
                    }
                    if let downloadData = data{
                        do{
                            let message = try JSONDecoder().decode(messageFromUrl.self, from: downloadData)
                            DispatchQueue.main.async(execute: {
                                let alertController = UIAlertController(title: "\(message)", message: nil, preferredStyle: .alert)
                                let cancelAction = UIAlertAction(title: "我知道了", style: .default, handler: nil)
                                alertController.addAction(cancelAction)
                                self.present(alertController, animated: true, completion: nil)
                            })
                        }catch{
                            print(error.localizedDescription)
                        }
                    }
                })
                task?.resume()
            }
//            let para = getKeyValue()

            
            
            
            
        }else{
            //全都没有修改，弹出警告视图，说没有数据被修改过
            let alertController = UIAlertController(title: "警告", message: "没有任何数据被修改过，无法上传数据", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "我知道了", style: .default, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func getKeyValue() -> [String:String]?{
        var para:[String:String] = [:]
        para.updateValue(inputNameTextField.text ?? "", forKey: "name")
        para.updateValue(inputGradeTextField.text ?? "", forKey: "grade")
        para.updateValue(inputBirthTextField.text ?? "", forKey: "birthday")
        para.updateValue(inoutPhoneTextField.text ?? "", forKey: "phone_number")
//        para.updateValue(inputStudentNOTextField.text ?? "", forKey: "s_no")
        return para
    }
    
}
