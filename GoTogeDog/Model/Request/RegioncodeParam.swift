//
//  RegioncodeRequest.swift
//  GoTogeDog
//
//  Created by 이숭인 on 2021/03/19.
//

import UIKit

struct RegioncodeParam {
    let x : String //lng
    let y : String //lat
    
    init(x:String, y:String){
        self.x = x
        self.y = y
    }
    
    var toDictionary : [String : Any] {
        let dict : [String : Any] = ["x":self.x,"y":self.y]
        return dict
    }
}

