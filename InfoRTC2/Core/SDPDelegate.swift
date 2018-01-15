//
//  SDPDelegate.swift
//  InfoRTC2
//
//  Created by Administrator on 2018. 1. 12..
//  Copyright © 2018년 root. All rights reserved.
//

import Foundation

class SDPDelegate: NSObject, RTCSessionDescriptionDelegate{
    
    var client: SocketClient? = nil
    
    init(_ socket: SocketClient) {
        client = socket
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection!, didCreateSessionDescription sdp: RTCSessionDescription!, error: Error!) {
        peerConnection.setLocalDescriptionWith(self, sessionDescription: sdp)
        print(error)
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection!, didSetSessionDescriptionWithError error: Error!) {
        if peerConnection.signalingState == RTCSignalingHaveLocalOffer{
            client?.sendSDPMessage(peerConnection.localDescription.description)
        }
        print(error)
    }
    
}
