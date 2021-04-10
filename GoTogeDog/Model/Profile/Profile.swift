//
//  Profile.swift
//  GoTogeDog
//
//  Created by 이숭인 on 2021/03/28.
//

import UIKit

struct Profile : Codable {
    var walkLocation : Document
    var dog : DogInfo
    var dogImages : DogImages
    var owner : OwnerInfo
    var ownerImages : OwnerImages
    
    init(walkLocation : Document, dog : DogInfo, dogImages : DogImages, owner : OwnerInfo, ownerImages : OwnerImages){
        self.walkLocation = walkLocation
        self.dog = dog
        self.dogImages = dogImages
        self.owner = owner
        self.ownerImages = ownerImages
    }
}

//struct WalkLocation : Codable {
//    var walkLocation : String
//    var regionCode : String
//    var toDictionary : [String : Any] {
//        let dict : [String : Any] = ["walkLocation":self.walkLocation, "regionCode":self.regionCode]
//
//        return dict
//    }
//
//    init(walkLocation : String, regionCode: String){
//        self.walkLocation = walkLocation
//        self.regionCode = regionCode
//    }
//}

struct DogInfo : Codable {
    var age : String
    var characters : [String]
    var kind : String
    var name : String
    
    var toDictionary : [String : Any] {
        let dict : [String : Any] = ["age":self.age, "characters":self.characters,
                                     "kind":self.kind,"name":self.name]
        
        return dict
    }
    
    init(age : String, characters : [String], kind : String, name : String){
        self.age = age
        self.characters = characters
        self.kind = kind
        self.name = name
    }
}

struct DogImages : Codable {
    var imageUrls : [String]
    
    var toDictionary : [String : Any] {
        let dict : [String : Any] = ["imageUrls":self.imageUrls]
        return dict
    }
    
    mutating func addUrl(url : URL){
        imageUrls.append("\(url)")
    }
    
    init(){
        imageUrls = [String]()
    }
}

struct OwnerInfo : Codable {
    var nickName : String
    var gender : String
    var age : String
    var introduce : String
    
    var toDictionary : [String : Any] {
        let dict : [String : Any] = ["nickName":self.nickName,"gender":self.gender,
                                     "age":self.age, "introduce":self.introduce]
        
        return dict
    }
    
    init(nickName : String, gender : String, age : String, introduce : String){
        self.nickName = nickName
        self.gender = gender
        self.age = age
        self.introduce = introduce
    }
}

struct OwnerImages : Codable {
    var imageUrls : [String]
    
    var toDictionary : [String : Any] {
        let dict : [String : Any] = ["imageUrls":self.imageUrls]
        return dict
    }
    
    mutating func addUrl(url : URL){
        imageUrls.append("\(url)")
    }
    
    init(){
        imageUrls = [String]()
    }
}
