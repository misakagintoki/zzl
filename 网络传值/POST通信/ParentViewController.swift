//
//  ParentViewController.swift
//  网络传值
//
//  Created by USER on 2019/02/26.
//  Copyright © 2019 ZZL. All rights reserved.
//

import UIKit

class ParentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func doAlert(title: String, message: String, okAction: UIAlertAction?, cancelAction: UIAlertAction?, style: UIAlertController.Style) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        if okAction != nil {
            alertController.addAction(okAction!)
        }
        if cancelAction != nil{
            alertController.addAction(cancelAction!)
        }
        return alertController
    }

}
