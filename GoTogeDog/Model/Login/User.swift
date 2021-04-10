//
//  User.swift
//  GoTogeDog
//
//  Created by 이숭인 on 2021/03/18.
//

import UIKit

struct User : Codable {
    var name : String
    var age : String
    var gender : String
    var id : String  // kakao id
    
    // use after fetchUserInfo
    var toDictionary : [String:String]{
        let dict : [String : String] = ["name":self.name,
                    "age":self.age,
                    "gender":self.gender,
                    "id":self.id]
        return dict
    }
    
    mutating func fetchUserInfo(name : String, age : String, gender : String, id : String){
        self.name = name
        self.age = age
        self.gender = gender
        self.id = id
    }
}
