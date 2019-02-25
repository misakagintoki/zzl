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
    
    //使用纯代码的方式，建立两个按键，一个叫做修改，一个叫做返回
    var changeButton:UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: ScreenSize.width / 4, y: 500, width: 50, height: 30)
        button.setTitle("修改", for: UIControl.State.normal)
        button.backgroundColor = UIColor.lightGray
        
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

        
        inputNameTextField.text = singleStudent?.name
        inputGradeTextField.text = singleStudent?.grade
        inputBirthTextField.text = singleStudent?.birthday
        inoutPhoneTextField.text = singleStudent?.phone_number
        
        self.view.addSubview(changeButton)
        self.view.addSubview(backButton)
    }
    

    @objc func backToMain(){
        dismiss(animated: true, completion: nil)
    }
    


}
