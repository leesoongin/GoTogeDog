//
//  Message.swift
//  GoTogeDog
//
//  Created by 이숭인 on 2021/05/18.
//

import UIKit

struct Message : Codable{
    let userId : String
    let message : String
    let time : String
    let isMine : Bool
    
    var toDictionary : [String:Any] {
        let dict : [String : Any] = [
                    "userId":self.userId,
                    "message" : self.message,
                    "time" : self.time,
                    "isMine" : self.isMine
                    ]
        return dict
    }
}
