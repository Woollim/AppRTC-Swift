//
//  SignInVC.swift
//  InfoRTC2
//
//  Created by 이병찬 on 2018. 1. 9..
//  Copyright © 2018년 root. All rights reserved.
//

import UIKit
import Firebase

class SignInVC: UIViewController {

    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        button.layer.cornerRadius = 8
    }
    
    @IBAction func signIn(_ sender: Any) {
        if idTextField.text!.isEmpty || pwTextField.text!.isEmpty{
            showToast(msg: "값을 모두 입력하세요.")
        }else{
            connector(add: "/signin", method: "POST", params: ["login_id" : idTextField.text!, "password" : pwTextField.text!], fun: {
                data in
                let parseData = try! JSONDecoder().decode(AuthModel.self, from: data)
                if parseData.status == "ko"{
                    self.showToast(msg: parseData.message != nil ? parseData.message! : "로그인 실패" )
                    self.idTextField.text = ""
                    self.pwTextField.text = ""
                }else{
                    let userData = parseData.result!.service_user
                    self.saveToken(userData.access_token)
                    self.showToast(msg: "\(userData.user_name!)님 환영합니다.", fun: self.goNext)
                }
            })
        }
    }
    
    func goNext(){
        self.dismiss(animated: true, completion: nil)
    }
    
}
