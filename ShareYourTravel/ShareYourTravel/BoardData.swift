//
//  BoardData.swift
//  ShareYourTravel
//
//  Created by Daeyun Ethan Kim on 27/08/2017.
//  Copyright © 2017 Daeyun Ethan Kim. All rights reserved.
//

import Foundation
import UIKit

struct BoardData {
    let id: String
    let nickname: String

    var content: String?
    var createTime: String? = nil
    var updateTime: String? = nil

    var category: String? = nil
    var images: NSArray? = nil
    var imageURLs = [String?]()
    
    init(id: String, nickname: String, content: String? = nil, createTime: String? = nil, updateTime: String? = nil, images: NSArray? = nil, imageURLs: [String?] = [String?]()) {
        self.id = id
        self.nickname = nickname
        self.content = content
        self.createTime = createTime
        self.updateTime = updateTime

        self.images = images
        self.imageURLs = imageURLs
    }
}
