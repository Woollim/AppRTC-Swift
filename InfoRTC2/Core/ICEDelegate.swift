//
//  IceDelegate.swift
//  InfoRTC2
//
//  Created by Administrator on 2018. 1. 12..
//  Copyright © 2018년 root. All rights reserved.
//

import Foundation

class ICEDelegate: NSObject, RTCPeerConnectionDelegate{
    
    var client: SocketClient? = nil
    
    init(_ socket: SocketClient) {
        client = socket
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection!, signalingStateChanged stateChanged: RTCSignalingState) {
        print("\(stateChanged)")
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection!, addedStream stream: RTCMediaStream!) {
        print("stream added")
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection!, removedStream stream: RTCMediaStream!) {
        print("stream removed")
    }
    
    func peerConnection(onRenegotiationNeeded peerConnection: RTCPeerConnection!) {
        print("재협상의 시간")
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection!, iceConnectionChanged newState: RTCICEConnectionState) {
        
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection!, iceGatheringChanged newState: RTCICEGatheringState) {
        
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection!, gotICECandidate candidate: RTCICECandidate!) {
        print(candidate.description + candidate.sdp)
        //client?.sendICEMessage(candidate: candidate.description, sdpMid: candidate.sdpMid, sdpMLineIndex: candidate.sdpMLineIndex)
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection!, didOpen dataChannel: RTCDataChannel!) {
        
    }
    
}
