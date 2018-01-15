//
//  UserInfoVC.swift
//  InfoRTC2
//
//  Created by Administrator on 2018. 1. 15..
//  Copyright © 2018년 root. All rights reserved.
//

import UIKit

class UserInfoVC: UITableViewController {

    var arr = [1,2,3,4,5,6,7,8,9,1,2,3,4,5,6,7,8]
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 108
    }
    
    @IBAction func logout(_ sender: Any) {
        removeToken()
        self.dismiss(animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        goNext("01022895997")
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserInfoCell", for: indexPath)
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            arr.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            
        }
    }
    
    func goNext(_ num: String){
        connector(add: "/users/\(num)/call", method: "POST", params: [:], fun: {
            data in
            let parseData = try! JSONDecoder().decode(SendMSGModel.self, from: data)
            if parseData.status == "ok"{
                let serviceToken = (parseData.result?.webrtc.topic)!
                let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "MainConnectionView") as! MainConnectionVC
                nextVC.vcid = num
                nextVC.serviceToken = serviceToken
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        })
    }

}

class UserInfoCell: UITableViewCell{

}
