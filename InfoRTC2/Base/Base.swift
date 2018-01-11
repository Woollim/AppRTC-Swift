//
//  Base.swift
//  InfoRTC2
//
//  Created by 이병찬 on 2018. 1. 9..
//  Copyright © 2018년 root. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func saveToken(_ token: String){
        let userDefaults = UserDefaults.standard
        userDefaults.set(token, forKey: "token")
    }
    
    func removeToken(){
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: "token")
    }
    
    func getToken() -> String?{
        let userDefaults = UserDefaults.standard
        return userDefaults.string(forKey: "token")
    }
    
    func connector(add: String, method: String, params: [String:String], fun: @escaping(Data) -> Void){
        let url = "https://webrtc.mand.co.kr/api/service"
        
        var paramStr = ""
        for param in params{ paramStr += "\(param.key)=\(param.value)&" }
        
        if !paramStr.isEmpty{ paramStr.removeLast() }
        
        var request: URLRequest? = nil
        if method == "GET" || method == "PUT"{
            request = URLRequest(url: URL(string: url + add + "?" +  paramStr)!)
        }else{
            request = URLRequest(url: URL(string: url + add)!)
            request?.httpBody = paramStr.data(using: .utf8)
        }
        
        if let token = getToken(){ request?.addValue(token, forHTTPHeaderField: "Authorization") }
        
        request?.httpMethod = method
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        URLSession.shared.dataTask(with: request!){
            data, res, err in
            
            let httpRes = res as? HTTPURLResponse
            
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                if httpRes == nil || err != nil{ self.showToast(msg: "네트워크 오류!") }
                else{
                    print(httpRes!.statusCode)
                    switch httpRes!.statusCode{
                    case 500: self.showToast(msg: "서버 오류")
                    default: fun(data!)
                    }
                }
            }
        }.resume()
        
    }
    
    func showToast(msg: String, fun: (() -> Void)? = nil){
        let toast = UILabel(frame: CGRect(x: 32, y: view.frame.height - 108 - 42, width: view.frame.size.width - 64, height: 42))
        toast.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        toast.textColor = UIColor.white
        toast.text = msg
        toast.textAlignment = .center
        toast.layer.cornerRadius = 8
        toast.clipsToBounds = true
        toast.autoresizingMask = [.flexibleTopMargin, .flexibleHeight, .flexibleWidth]
        view.addSubview(toast)
        
        UIView.animate(withDuration: 0.4, delay: 0.3, options: .curveEaseOut, animations: {
            toast.alpha = 0.5
        }, completion: { _ in
            toast.removeFromSuperview()
            fun?()
        })
        
    }
    
}
