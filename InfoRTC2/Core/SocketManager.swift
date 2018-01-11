//
//  SocketManager.swift
//  InfoRTC2
//
//  Created by 이병찬 on 2018. 1. 11..
//  Copyright © 2018년 root. All rights reserved.
//

import Foundation
import SocketRocket

class SocketManager{
    
    var client: SRWebSocket? = nil
    
    init(topic: String, token: String) {
        client = SRWebSocket.init(url: URL.init(string: "https://webrtc.mand.co.kr/api/service/service/ws/\(topic)?access_token=\(token)"))
        client?.open()
    }
    
    func sendMessage(msg: Data){
        client?.send(msg)
    }
    
    deinit {
        client?.close()
    }
    
}
