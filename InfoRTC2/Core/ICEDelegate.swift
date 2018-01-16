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
    var remoteTrackFunc: ((RTCMediaStream) -> ())? = nil
    var remoteMedia: RTCMediaStream? = nil
    
    init(_ socket: SocketClient) {
        client = socket
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection!, signalingStateChanged stateChanged: RTCSignalingState) {
        
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection!, addedStream stream: RTCMediaStream!) {
        print("set remote stream")
        remoteMedia = stream
        remoteTrackFunc?(stream)
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection!, removedStream stream: RTCMediaStream!) {
        print("stream removed")
    }
    
    func peerConnection(onRenegotiationNeeded peerConnection: RTCPeerConnection!) {
        print("재협상의 시간")
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection!, iceConnectionChanged newState: RTCICEConnectionState) {
        switch newState {
        case RTCICEConnectionNew: print("new connection")
        case RTCICEConnectionChecking: print("checking")
        case RTCICEConnectionConnected: print("connected")
        case RTCICEConnectionCompleted: print("completed")
            print(remoteMedia?.videoTracks[0])
        case RTCICEConnectionFailed: print("connection failed")
        case RTCICEConnectionDisconnected: print("disconnected")
        case RTCICEConnectionClosed: print("close")
        case RTCICEConnectionMax: print("max room")
        default: print("else")
        }
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection!, iceGatheringChanged newState: RTCICEGatheringState) {
        print("gathering connection change")
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection!, gotICECandidate candidate: RTCICECandidate!) {
        client?.sendICEMessage(candidate: candidate.description, sdpMid: candidate.sdpMid, sdpMLineIndex: candidate.sdpMLineIndex)
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection!, didOpen dataChannel: RTCDataChannel!) {
        
    }
    
}
