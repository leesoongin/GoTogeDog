//
//  User.swift
//  GoTogeDog
//
//  Created by 이숭인 on 2021/03/18.
//

import UIKit

//TODO : 네트워킹 아님!! 어떻게 분류해야할지모르곘음 ,, ㅋㅅㅋ

class UserInfoManager {
    static let shared = UserInfoManager()
    
    var userInfo : [String:String]{
        return UserDefaults.standard.value(forKey : "userInfo") as! [String:String]
    }
    
    func setUserInfo(userInfo : [String:String]){
        UserDefaults.standard.set(userInfo, forKey: "userInfo")
    }
}
