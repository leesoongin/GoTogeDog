//
//  ChatRoomViewModel.swift
//  GoTogeDog
//
//  Created by 이숭인 on 2021/05/18.
//

import UIKit

class ChatRoomViewModel {
    static let shared = ChatRoomViewModel()
    
    var messages : [Message] = [Message]()
    
    func addMessages(userId : String, message : String){
        var formatter_time = DateFormatter()
        formatter_time.dateFormat = "HH:mm"
        var current_time_string = formatter_time.string(from: Date())

        self.messages.append(Message(userId : userId, message: message,time: current_time_string ,isMine: true))
    }
    
    func extendMessages(messages : [Message]){
        self.messages.append(contentsOf: messages)
    }
    func clearMessages(){
        self.messages.removeAll()
    }
    
    func messagesToDictionary() -> [[String : Any]]{
        var dict : [[String:Any]] = []
        for item in self.messages{
            dict.append(item.toDictionary)
        }
        return dict
    }
}
