//
//  PrepareVC.swift
//  InfoRTC2
//
//  Created by Administrator on 2018. 1. 15..
//  Copyright © 2018년 root. All rights reserved.
//

import UIKit
import Firebase

class PrepareVC: UIViewController {

    override func viewDidLoad() {
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if getToken() != nil{
            goNext("UserInfoView")
        }else{
            goNext("SignInView")
        }
    }
    
    func goNext(_ id: String){
        let nextVC = storyboard!.instantiateViewController(withIdentifier: id)
        present(nextVC, animated: true, completion: nil)
    }
    
}
