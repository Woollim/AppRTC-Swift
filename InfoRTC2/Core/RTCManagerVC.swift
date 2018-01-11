//
//  ARDClient.swift
//  InfoRTC2
//
//  Created by 이병찬 on 2018. 1. 10..
//  Copyright © 2018년 root. All rights reserved.
//

import Foundation
import SocketRocket
import AVFoundation

class RTCManagerVC: UIViewController{
    
    var socketClient: SocketManager? = nil
    
    var serviceToken = ""
    var phoneNum = "01022895997"
    
    override func viewDidLoad() {
        socketClient = SocketManager.init(topic: serviceToken, token: getToken() != nil ? getToken()! : "")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        RTCPeerConnectionFactory.deinitializeSSL()
    }
    
    func createIceServer(urls: Array<Url>){
        var sIceServerArr = Array<RTCICEServer>()
        var tIceServerArr = Array<RTCICEServer>()
        for urlPack in urls{
            for url in urlPack.urls{
                let iceServer = RTCICEServer.init(uri: URL(string: url)!, username: urlPack.username != nil ? urlPack.username! : "", password: urlPack.credential != nil ? urlPack.credential! : "")
                if url.hasPrefix("turn"){ tIceServerArr.append(iceServer!) }
                else{ sIceServerArr.append(iceServer!) }
            }
        }
        startPeerConnection(tIceServerArr.count > 0 ? sIceServerArr : tIceServerArr)
    }
    
    func startPeerConnection(_ servers: Array<RTCICEServer>){
        RTCPeerConnectionFactory.initializeSSL()
        let peerFactory = RTCPeerConnectionFactory()
        let msg = IceCandidateModel.init(vcid: phoneNum, cmd: "icecandidate-to", sdpMid: "", sdpMLineIndex: 0, candidate: "")
        let peerDelegate = RTCManagerPeerDelegate(msg: msg)
        let peerConnection = peerFactory.peerConnection(withICEServers: servers, constraints: getPeerConnectionConstraints(), delegate: peerDelegate)!
        peerDelegate?.peerConnection = peerConnection
        peerDelegate?.socket = socketClient
        peerConnection.add(setStream(factory: peerFactory))
        createOffer(peer: peerConnection)
    }
    
    func setStream(factory: RTCPeerConnectionFactory) -> RTCMediaStream{
        let localStream = factory.mediaStream(withLabel: "InfoMedia")
        let audioTrack = factory.audioTrack(withID: "InfoAudio")
        localStream!.addAudioTrack(audioTrack!)
        let device = AVCaptureDevice.DiscoverySession.init(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .front).devices[0]
        let rtcVideoSource = RTCVideoCapturer.init(deviceName: device.localizedName)
        let videoSource = factory.videoSource(with: rtcVideoSource, constraints: nil)
        let videoTrack = factory.videoTrack(withID: "InfoVideo", source: videoSource)
        localStream!.addVideoTrack(videoTrack!)
        return localStream!
    }
    
    func createOffer(peer: RTCPeerConnection){
        peer.createOffer(with: self, constraints: getOfferConstraints())
    }
    
}

extension RTCManagerVC: RTCSessionDescriptionDelegate{
    
    func peerConnection(_ peerConnection: RTCPeerConnection!, didCreateSessionDescription sdp: RTCSessionDescription!, error: Error!) {
        let sendData = SDPModel.init(audio: 1, video: 1, vcid: phoneNum, cmd: "invite-video-call", sdpOffer: sdp.description, sdpAnswer: nil)
        socketClient?.sendMessage(msg: try! JSONEncoder().encode(sendData))
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection!, didSetSessionDescriptionWithError error: Error!) {
        print(error)
    }
    
    func getOfferConstraints() -> RTCMediaConstraints{
        let constraint = RTCMediaConstraints.init(mandatoryConstraints: [RTCPair.init(key: "OfferToReceiveAudio", value: "true"), RTCPair.init(key: "OfferToReceiveVideo", value: "true")], optionalConstraints: nil)
        return constraint!
    }
    
    func getPeerConnectionConstraints() -> RTCMediaConstraints{
        let constraint = RTCMediaConstraints.init(mandatoryConstraints: nil, optionalConstraints: [RTCPair.init(key: "DtlsSrtpKeyAgreement", value: "true")])
        return constraint!
    }
    
}
