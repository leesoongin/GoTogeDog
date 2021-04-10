//
//  DummyModel.swift
//  GoTogeDog
//
//  Created by 이숭인 on 2021/04/06.
//

import UIKit

struct DummyModel : Codable{
    var name : String
    var age : String
    var kind : String
    var address : String
    var imageUrl : String
    
    init(name : String, age : String, kind : String, address : String, imageUrl : String){
        self.name = name
        self.age = age
        self.kind = kind
        self.address = address
        self.imageUrl = imageUrl
    }
    
    
}
