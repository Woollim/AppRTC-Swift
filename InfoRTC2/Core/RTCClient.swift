//
//  RTCClient.swift
//  InfoRTC2
//
//  Created by Administrator on 2018. 1. 12..
//  Copyright © 2018년 root. All rights reserved.
//

import Foundation
import AVFoundation
import SocketRocket

class RTCClient: NSObject, SRWebSocketDelegate{
    
    var peerConn: RTCPeerConnection? = nil
    
    var socket: SocketClient? = nil
    var sdpDelegate: SDPDelegate? = nil
    var iceDelegate: ICEDelegate? = nil
    
    var delegate: RTCDelegate? = nil
    
    var socketIsOpen = false
    
    init(_ delegate: RTCDelegate, token: String, topic: String, vcid: String) {
        super.init()
        self.delegate = delegate
        socket = SocketClient.init(self, token: token, topic: topic, vcid: vcid)
        sdpDelegate = SDPDelegate(socket!)
        iceDelegate = ICEDelegate(socket!)
    }
    
    func webSocket(_ webSocket: SRWebSocket!, didReceiveMessage message: Any!) {
        print(message)
    }
    
    func webSocketDidOpen(_ webSocket: SRWebSocket!) {
        socketIsOpen = true
        if iceServerArr.count > 0 { startPeerConnection(iceServerArr) }
    }
    
    var iceServerArr = Array<RTCICEServer>()
    
    func createIceServer(_ urlPack: Array<UrlModel>){
        var sIceServerArr = Array<RTCICEServer>()
        var tIceServerArr = Array<RTCICEServer>()
        for urls in urlPack{
            for url in urls.urls{
                let iceServer = RTCICEServer.init(uri: URL(string: url)!, username: urls.username != nil ? urls.username! : "", password: urls.credential != nil ? urls.credential! : "")
                if url.hasPrefix("turn"){ tIceServerArr.append(iceServer!) }
                else{ sIceServerArr.append(iceServer!) }
            }
        }
        iceServerArr = sIceServerArr
        if socketIsOpen{ startPeerConnection(iceServerArr) }
    }
    
    func startPeerConnection(_ servers: Array<RTCICEServer>){
        RTCPeerConnectionFactory.initializeSSL()
        let peerFactory = RTCPeerConnectionFactory()
        peerConn = peerFactory.peerConnection(withICEServers: servers, constraints: getPeerConstraints(), delegate: iceDelegate)
        guard let stream = createStream(peerFactory) else { return print("전면 카메라 없음") }
        peerConn?.add(stream)
        createOffer()
    }
    
    func createStream(_ factory: RTCPeerConnectionFactory) -> RTCMediaStream?{
        let localStream = factory.mediaStream(withLabel: "localStreamIB")
        let audioTrack = factory.audioTrack(withID: "audioIB")
        localStream?.addAudioTrack(audioTrack)
        guard let deviceName = getVideoDevice() else { return nil }
        let videoCapturer = RTCVideoCapturer.init(deviceName: deviceName)
        let videoSource = factory.videoSource(with: videoCapturer, constraints: nil)
        let videoTrack = factory.videoTrack(withID: "videoIB", source: videoSource)
        delegate?.getLocalTrack(videoTrack!)
        localStream?.addVideoTrack(videoTrack)
        return localStream!
    }
    
    func createOffer(){
        peerConn?.createOffer(with: sdpDelegate, constraints: getOfferConstraints())
    }
    
}

extension RTCClient{
    
    //get media constraints
    
    func getPeerConstraints() -> RTCMediaConstraints{
        return getConstraints(main: nil, option: [RTCPair.init(key: "DtlsSrtpKeyAgreement", value: "true")])
    }
    
    func getOfferConstraints() -> RTCMediaConstraints{
        return getConstraints(main: [RTCPair.init(key: "OfferToReceiveAudio", value: "true"), RTCPair.init(key: "OfferToReceiveVideo", value: "true")], option: nil)
    }
    
    func getConstraints(main: [RTCPair]?, option: [RTCPair]?) -> RTCMediaConstraints{
        return RTCMediaConstraints.init(mandatoryConstraints: main, optionalConstraints: option)
    }
    
    //get video device
    func getVideoDevice() -> String?{
        let videoDeviceArr = AVCaptureDevice.DiscoverySession.init(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .front)
        if videoDeviceArr.devices.count < 0 { return nil }
        else{ return videoDeviceArr.devices[0].localizedName }
    }
    
}
