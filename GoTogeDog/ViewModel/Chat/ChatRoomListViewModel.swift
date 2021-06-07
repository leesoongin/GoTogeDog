//
//  ChatRoomListViewModel.swift
//  GoTogeDog
//
//  Created by 이숭인 on 2021/05/20.
//

import UIKit

class ChatRoomListViewModel  {
    static let shared = ChatRoomListViewModel()
    
    var rooms : [ChatRoom] = [ChatRoom]()
    
    func addRoom(room : ChatRoom){
        self.rooms.append(room)
    }
    func clearRooms(){
        self.rooms.removeAll()
    }
}
