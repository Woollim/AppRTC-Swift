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
    let factory = RTCPeerConnectionFactory()
    
    var socket: SocketClient? = nil
    var sdpDelegate: SDPDelegate? = nil
    var iceDelegate: ICEDelegate? = nil
    
    var delegate: RTCDelegate? = nil
    
    var socketIsOpen = false
    var timer: Timer? = nil
    
    init(_ delegate: RTCDelegate, token: String, topic: String, vcid: String) {
        super.init()
        self.delegate = delegate
        socket = SocketClient.init(self, token: token, topic: topic, vcid: vcid)
        sdpDelegate = SDPDelegate(socket!)
        iceDelegate = ICEDelegate(socket!)
        iceDelegate?.remoteTrackFunc = setRemoteStream
    }
    
    func webSocket(_ webSocket: SRWebSocket!, didReceiveMessage message: Any!) {
        let data = (message as! String).data(using: .utf8)!
        do{
            let sdpData = try JSONDecoder().decode(SocketSDPModel.self, from: data)
            setSdp(sdpData.sdpAnswer)
        }catch{
            let iceData = try! JSONDecoder().decode(SocketICEModel.self, from: data).candidate
            setICE(candidate: iceData.candidate, sdpMid: iceData.sdpMid, sdpMLineIndex: iceData.sdpMLineIndex)
        }
    }
    
    
    func webSocket(_ webSocket: SRWebSocket!, didCloseWithCode code: Int, reason: String!, wasClean: Bool) {
        print("close/" + reason)
    }
    
    func webSocketDidOpen(_ webSocket: SRWebSocket!) {
        print("socket open")
        socketIsOpen = true
        if iceServerArr.count > 0 { startPeerConnection(iceServerArr) }
//        timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true, block: {
//            _ in
//            print("ping")
//            let data = SocketPingModel.init(cmd: "ping")
//            let sendData = try! JSONEncoder().encode(data)
//            print(String.init(data: sendData, encoding: .utf8))
//            self.socket?.client?.send(sendData)
//        })
    }
    
    var iceServerArr = Array<RTCICEServer>()
    
    func createIceServer(_ urlPack: Array<UrlModel>){
        var tempIceServerArr = Array<RTCICEServer>()
        for urls in urlPack{
            for url in urls.urls{
                let iceServer = RTCICEServer.init(uri: URL(string: url)!, username: urls.username != nil ? urls.username! : "", password: urls.credential != nil ? urls.credential! : "")
                if !url.contains("["){ tempIceServerArr.append(iceServer!) }
            }
        }
        iceServerArr = tempIceServerArr
    }
    
    func startPeerConnection(_ servers: Array<RTCICEServer>){
        RTCPeerConnectionFactory.initializeSSL()
        peerConn = factory.peerConnection(withICEServers: servers, constraints: getPeerConstraints(), delegate: iceDelegate)
        guard let stream = createStream() else { return print("전면 카메라 없음") }
        peerConn?.add(stream)
        createOffer()
    }
    
    func createStream() -> RTCMediaStream?{
        let localStream = factory.mediaStream(withLabel: "ARDAMS")
        
        guard let deviceName = getVideoDevice() else { return nil }
        let videoCapturer = RTCVideoCapturer.init(deviceName: deviceName)
        let videoSource = factory.videoSource(with: videoCapturer, constraints: getConstraints(main: nil, option: nil))
        let videoTrack = factory.videoTrack(withID: "ARDAMSv0", source: videoSource)
        delegate?.getLocalTrack(videoTrack!)
        
        localStream?.addVideoTrack(videoTrack)
        let audioTrack = factory.audioTrack(withID: "ARDAMSa0")
        localStream?.addAudioTrack(audioTrack)
        
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
    
    //set sdp, icecandidate
    func setSdp(_ sdp: String){
        let remoteSdp = RTCSessionDescription.init(type: "answer", sdp: sdp)
        peerConn?.setRemoteDescriptionWith(nil, sessionDescription: remoteSdp)
    }
    
    func setICE(candidate: String, sdpMid: String, sdpMLineIndex: Int){
        let remoteCandidate = RTCICECandidate.init(mid: sdpMid, index: sdpMLineIndex, sdp: candidate)
        peerConn?.add(remoteCandidate)
    }
    
    //set remote track
    func setRemoteStream(_ stream: RTCMediaStream){
        DispatchQueue.main.async {
            self.delegate?.getRemoteTrack(stream.videoTracks[0] as! RTCVideoTrack)
        }
    }
    
}
