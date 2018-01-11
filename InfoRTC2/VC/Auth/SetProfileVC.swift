//
//  SetProfileVC.swift
//  InfoRTC2
//
//  Created by 이병찬 on 2018. 1. 9..
//  Copyright © 2018년 root. All rights reserved.
//

import UIKit

class SetProfileVC: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var pwCheckTextField: UITextField!
    
    @IBAction func change(_ sender: Any) {
        if nameTextField.text!.isEmpty || pwTextField.text!.isEmpty || pwCheckTextField.text!.isEmpty{
            showToast(msg: "값을 다 입력하세요")
        }else{
            
        }
    }
    
}
