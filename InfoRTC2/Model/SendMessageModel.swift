//
//  SendMessageModel.swift
//  InfoRTC2
//
//  Created by 이병찬 on 2018. 1. 9..
//  Copyright © 2018년 root. All rights reserved.
//

import Foundation

struct SendMSGModel: Codable{
    
    var status: String
    var message: String?
    var result: ResultModel?
    
    struct ResultModel: Codable {
        
        var webrtc: WebRTC
        
        struct WebRTC: Codable{
            var topic: String
            var expires_in: Int
        }
        
    }
    
}
