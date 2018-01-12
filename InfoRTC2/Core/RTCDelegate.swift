//
//  File.swift
//  InfoRTC2
//
//  Created by Administrator on 2018. 1. 12..
//  Copyright © 2018년 root. All rights reserved.
//

import Foundation

protocol RTCDelegate{
    
    func getLocalTrack(_ localTrack: RTCVideoTrack)
    
    func getRemoteTrack(_ remoteTrack: RTCVideoTrack)
    
}
