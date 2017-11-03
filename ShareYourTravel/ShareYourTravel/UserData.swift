//
//  UserData.swift
//  ShareYourTravel
//
//  Created by Daeyun Ethan Kim on 03/09/2017.
//  Copyright © 2017 Daeyun Ethan Kim. All rights reserved.
//

import Foundation

struct UserData {
    let id: String
    let nickname: String
    var createTime: String? = nil
    var token: String? = nil
    
    init(id: String, nickname: String, createTime: String? = nil) {
        self.id = id
        self.nickname = nickname
        self.createTime = createTime
    }
}
