//
//  IceCandidateModel.swift
//  InfoRTC2
//
//  Created by 이병찬 on 2018. 1. 11..
//  Copyright © 2018년 root. All rights reserved.
//

import Foundation

struct ICEModel: Codable{
    
    var cmd: String
    var vcid: String
    var candidate: String
    var sdpMid: String
    var sdpMLineIndex: Int
    
}
