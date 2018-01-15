//
//  File.swift
//  InfoRTC2
//
//  Created by Administrator on 2018. 1. 15..
//  Copyright © 2018년 root. All rights reserved.
//

import Foundation

struct SocketSDPModel: Codable{
    
    var cmd: String
    var vcid: String
    var caller: UserInfo
    var sdpAnswer: String
    
}

struct UserInfo: Codable{
    var id: Int
    var email: String?
    var fullName: String
    var room_id: String
    var customer: Bool
}
