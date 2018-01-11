//
//  RTCManagerPeerDelegate.swift
//  InfoRTC2
//
//  Created by 이병찬 on 2018. 1. 11..
//  Copyright © 2018년 root. All rights reserved.
//

import Foundation

class RTCManagerPeerDelegate: NSObject, RTCPeerConnectionDelegate{
    
    var socket: SocketManager? = nil
    var sendMsg: IceCandidateModel? = nil
    var peerConnection: RTCPeerConnection? = nil
    
    init(msg: IceCandidateModel) {
        self.sendMsg = msg
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection!, signalingStateChanged stateChanged: RTCSignalingState) { }
    
    func peerConnection(_ peerConnection: RTCPeerConnection!, addedStream stream: RTCMediaStream!) { }
    
    func peerConnection(_ peerConnection: RTCPeerConnection!, removedStream stream: RTCMediaStream!) { }
    
    func peerConnection(onRenegotiationNeeded peerConnection: RTCPeerConnection!) { }
    
    func peerConnection(_ peerConnection: RTCPeerConnection!, iceConnectionChanged newState: RTCICEConnectionState) { }
    
    func peerConnection(_ peerConnection: RTCPeerConnection!, iceGatheringChanged newState: RTCICEGatheringState) { }
    
    func peerConnection(_ peerConnection: RTCPeerConnection!, gotICECandidate candidate: RTCICECandidate!) {
        sendMsg?.candidate = candidate.description
        sendMsg?.sdpMid = candidate.sdpMid
        sendMsg?.sdpMLineIndex = candidate.sdpMLineIndex
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection!, didOpen dataChannel: RTCDataChannel!) { }
    
}
