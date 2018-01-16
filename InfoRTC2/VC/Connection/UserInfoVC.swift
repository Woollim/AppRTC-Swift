//
//  UserInfoVC.swift
//  InfoRTC2
//
//  Created by Administrator on 2018. 1. 15..
//  Copyright © 2018년 root. All rights reserved.
//

import UIKit

class UserInfoVC: UITableViewController {

    var arr = Array<String>()
    
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
        goNext(arr[indexPath.row])
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserInfoCell", for: indexPath) as! UserInfoCell
        cell.numLabel.text = arr[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            arr.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func goNext(_ num: String){
        connector(add: "/users/\(num)/call?mock=1", method: "POST", params: [:], fun: {
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

extension UserInfoVC{
    
    @IBAction func add(){
        let alert = UIAlertController.init(title: "사용자 추가", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        let textField = alert.textFields![0]
        textField.keyboardType = .numberPad
        alert.addAction(UIAlertAction.init(title: "추가", style: .default, handler: {
            _ in
            let textField = alert.textFields![0]
            if textField.text!.isEmpty{ self.showToast(msg: "번호를 입력하세요") }
            else {
                self.arr.append(textField.text!)
                self.tableView.reloadData()
            }
        }))
        alert.addAction(UIAlertAction.init(title: "취소", style: .destructive, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}

class UserInfoCell: UITableViewCell{

    @IBOutlet weak var numLabel: UILabel!
    
}
