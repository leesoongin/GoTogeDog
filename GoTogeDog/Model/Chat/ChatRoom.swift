//
//  ChatRoom.swift
//  GoTogeDog
//
//  Created by 이숭인 on 2021/03/16.
//

import UIKit
protocol ChatRoomItem {
    var profile_image_path : UIImage { get }
    var nickName : String { get }
    var lastMessage : String { get }
}

struct ChatRoom : ChatRoomItem {
    var profile_image_path: UIImage
    var nickName: String
    var lastMessage: String
}
