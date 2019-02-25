//
//  SingleStudentInfoViewController.swift
//  网络传值
//
//  Created by USER on 2019/02/25.
//  Copyright © 2019 ZZL. All rights reserved.
//

import UIKit

class SingleStudentInfoViewController: UIViewController {

    
    @IBOutlet weak var inputNameTextField: UITextField!
    @IBOutlet weak var inputGradeTextField: UITextField!
    @IBOutlet weak var inputBirthTextField: UITextField!
    @IBOutlet weak var inoutPhoneTextField: UITextField!
    
    var singleStudent:SingleStudentDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        inputNameTextField.text = singleStudent?.name
        inputGradeTextField.text = singleStudent?.grade
        inputBirthTextField.text = singleStudent?.birthday
        inoutPhoneTextField.text = singleStudent?.phone_number
    }
    



}
