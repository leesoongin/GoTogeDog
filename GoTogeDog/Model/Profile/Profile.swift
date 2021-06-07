//
//  Profile.swift
//  GoTogeDog
//
//  Created by 이숭인 on 2021/03/28.
//

import UIKit

struct Profile : Codable {
    var WalkLocation : Document
    var Dog : DogInfo
    var DogImages : DogImages
    var Owner : OwnerInfo
    var OwnerImages : OwnerImages
    
    init(walkLocation : Document, dog : DogInfo, dogImages : DogImages, owner : OwnerInfo, ownerImages : OwnerImages){
        self.WalkLocation = walkLocation
        self.Dog = dog
        self.DogImages = dogImages
        self.Owner = owner
        self.OwnerImages = ownerImages
    }
    
    var toDictionary : [String: Any]{
        let dict : [String : Any] = [
            "WalkLocation" : self.WalkLocation.toDictionary,
            "Dog" : self.Dog.toDictionary,
            "DogImages" : self.DogImages.toDictionary,
            "Owner" : self.Owner.toDictionary,
            "OwnerImages" : self.OwnerImages.toDictionary
        ]
        
        return dict
    }
}


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
