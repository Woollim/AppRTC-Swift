//
//  EnterPhoneNumVC.swift
//  InfoRTC2
//
//  Created by 이병찬 on 2018. 1. 9..
//  Copyright © 2018년 root. All rights reserved.
//

import UIKit

class EnterPhoneNumVC: UIViewController {

    @IBOutlet weak var numberTextField: UITextField!
    var selected = false
    
    override func viewDidLoad() {
    }
    
    @IBAction func calling(_ sender: Any) {
        if numberTextField.text!.isEmpty{
            showToast(msg: "번호를 입력하세요")
        }else{
            if selected{ return }
            selected = true
            connector(add: "/users/\(numberTextField.text!)/call", method: "POST", params: [:], fun: {
                data in
                let parseData = try! JSONDecoder().decode(SendMSGModel.self, from: data)
                if parseData.status == "ok"{
                    let serviceToken = (parseData.result?.webrtc.topic)!
                    print("url : " + parseData.message!)
                    let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "MainConnectionView") as! MainConnectionVC
                    nextVC.vcid = "01022895997"
                    nextVC.serviceToken = serviceToken
                    self.present(nextVC, animated: true, completion: nil)
                }else{
                    self.selected = false
                    self.showToast(msg: "통화 실패")
                    print(parseData.message!)
                }
            })
        }
    }
    
}
