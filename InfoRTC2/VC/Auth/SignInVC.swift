//
//  SignInVC.swift
//  InfoRTC2
//
//  Created by 이병찬 on 2018. 1. 9..
//  Copyright © 2018년 root. All rights reserved.
//

import UIKit

class SignInVC: UIViewController {

    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    
    @IBAction func signIn(_ sender: Any) {
        if idTextField.text!.isEmpty || pwTextField.text!.isEmpty{
            showToast(msg: "값을 입력하세요.")
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
                    self.showToast(msg: "\(userData.user_name)님 환영합니다.")
                    self.saveToken(userData.access_token)
                    let nextVC = UIStoryboard.init(name: "Connect", bundle: nil).instantiateViewController(withIdentifier: "EnterPhoneNumView") as! EnterPhoneNumVC
                    self.present(nextVC, animated: true, completion: nil)
                }
            })
        }
    }
    
}
