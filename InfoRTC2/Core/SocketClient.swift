//
//  SocketClient.swift
//  InfoRTC2
//
//  Created by Administrator on 2018. 1. 12..
//  Copyright © 2018년 root. All rights reserved.
//

import Foundation
import SocketRocket

class SocketClient{
    
    var client: SRWebSocket? = nil
    var vcid = ""
    
    var timer: Timer? = nil
    
    init(_ delegate: SRWebSocketDelegate, token: String, topic: String, vcid: String) {
        client = SRWebSocket.init(url: URL(string: "https://webrtc.mand.co.kr/service/ws/\(topic)?access_token=\(token)")!)
        client?.delegate = delegate
        self.vcid = vcid
        client?.open()
    }
    
    func sendSDPMessage(_ sdpOffer: String){
        print("sendSDP")
        let sendData = SDPModel.init(cmd: "invite-video-call-to", vcid: vcid, audio: 1, video: 1, sdpOffer: sdpOffer)
        let temp = try! JSONEncoder().encode(sendData)
        self.sendMessage(temp)
    }
    
    func sendICEMessage(candidate: String, sdpMid: String, sdpMLineIndex: Int){
        print("sendICE")
        let sendData = ICEModel.init(cmd: "icecandidate-to", vcid: vcid, candidate: candidate, sdpMid: sdpMid, sdpMLineIndex: sdpMLineIndex)
        sendMessage(try! JSONEncoder().encode(sendData))
    }
    
    func sendMessage(_ data: Data){
        client?.send(data)
    }
    
}
