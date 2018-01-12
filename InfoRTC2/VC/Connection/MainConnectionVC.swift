//
//  MainConnectionVC.swift
//  InfoRTC2
//
//  Created by 이병찬 on 2018. 1. 9..
//  Copyright © 2018년 root. All rights reserved.
//


import UIKit
import SocketRocket

class MainConnectionVC: UIViewController {
    
    @IBOutlet weak var remoteView: RTCEAGLVideoView!
    @IBOutlet weak var localView: RTCEAGLVideoView!
    
    var localTrack: RTCVideoTrack? = nil
    var remoteTrack: RTCVideoTrack? = nil
    
    var vcid = ""
    var serviceToken = ""
    var client: RTCClient? = nil
    
    func initRTC(){
        client = RTCClient.init(self, token: getToken()!, topic: serviceToken, vcid: vcid)
    }
    
    override func viewDidLoad() {
        initRTC()
        connector(add: "/ice_servers", method: "GET", params: [:], fun: {
            data in
            let parseData = try! JSONDecoder().decode(IceServerModel.self, from: data)
            if parseData.status == "ok"{
                self.client?.createIceServer(parseData.result!.ice_servers)
            }else{
                self.showToast(msg: "연결할 수 있는 서버가 없습니다.")
            }
        })
    }

}

extension MainConnectionVC: RTCDelegate{
    
    func getLocalTrack(_ localTrack: RTCVideoTrack) {
        self.localTrack = localTrack
        self.localTrack?.add(localView)
    }
    
    func getRemoteTrack(_ remoteTrack: RTCVideoTrack) {
        self.remoteTrack = remoteTrack
        self.remoteTrack?.add(remoteView)
    }
    
}
