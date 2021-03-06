//
//  IceListModel.swift
//  InfoRTC2
//
//  Created by 이병찬 on 2018. 1. 9..
//  Copyright © 2018년 root. All rights reserved.
//

import Foundation

struct IceServerModel: Codable{
    
    var status: String
    var message: String?
    var result: ResultModel?
    
    struct ResultModel: Codable {
        var ice_servers: Array<UrlModel>
    }
    
}

struct UrlModel: Codable{
    var urls: Array<String>
    var credential: String?
    var username: String?
}
