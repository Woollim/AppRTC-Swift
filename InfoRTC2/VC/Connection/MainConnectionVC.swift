//
//  MainConnectionVC.swift
//  InfoRTC2
//
//  Created by 이병찬 on 2018. 1. 9..
//  Copyright © 2018년 root. All rights reserved.
//


import UIKit
import SocketRocket

class MainConnectionVC: RTCManagerVC {
    
    @IBOutlet weak var remoteView: RTCEAGLVideoView!
    @IBOutlet weak var localView: RTCEAGLVideoView!
    
    var localTrack: RTCVideoTrack? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        connector(add: "/ice_servers", method: "GET", params: [:], fun: {
            data in
            let parseData = try! JSONDecoder().decode(IceListModel.self, from: data)
            if parseData.status == "ok"{
                self.createIceServer(urls: parseData.result!.ice_servers)
            }else{
                self.showToast(msg: "연결할 수 있는 서버가 없습니다.")
            }
        })
    }

}
