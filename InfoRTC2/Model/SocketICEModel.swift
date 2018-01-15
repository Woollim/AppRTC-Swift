//
//  SocketICEModel.swift
//  InfoRTC2
//
//  Created by Administrator on 2018. 1. 15..
//  Copyright © 2018년 root. All rights reserved.
//

import Foundation

struct SocketICEModel: Codable{
    
    var cmd: String
    var candidate: Result

    struct Result: Codable{
        var sender: UserInfo
        var vcid: String
        var candidate: String
        var sdpMid: String
        var sdpMLineIndex: Int
    }
}
