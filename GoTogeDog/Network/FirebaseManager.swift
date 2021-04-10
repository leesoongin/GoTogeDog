//
//  FirebaseManager.swift
//  GoTogeDog
//
//  Created by 이숭인 on 2021/03/18.
//

import UIKit
import Firebase

class FirebaseManager {
    //database structed single_tone pattern
    static let shared = FirebaseManager()
    
    let db = Database.database().reference()
    let userInfoManager = UserInfoManager.shared
    //MARK: - UserInfo
    func saveUserInfo(userInfo : [String:String]){
        db.child("User").child(userInfo["id"]!).setValue(userInfo)
    }
    func loadUserInfo(id : String,completion : @escaping (User)->(Void)){
        db.child("User").child(id).observeSingleEvent(of: .value) { snapshot in
            if !snapshot.hasChildren()  {
                //데이터가 없으면 해야할 행동
                print("don't have review data")
                return
            }
            do{
                let jsonData = try JSONSerialization.data(withJSONObject: snapshot.value!, options: [])
                let json = try JSONDecoder().decode(User.self, from: jsonData)
                
                completion(json)
            }catch let error{
                print("parsed error --> \(error.localizedDescription)")
            }
        }
    }
    //MARK: -walkLocation
    func saveProfileWalkLocation(id : String, walkLocation : Document){
        //프로필에 위치 정보 저장
        db.child("Profile").child(id).child("WalkLocation").setValue(walkLocation.toDictionary)
        //지역별 유저 등록
        guard let key = db.child("\(walkLocation.region_1depth_name)").child("\(walkLocation.region_2depth_name)").childByAutoId().key else { return }
        let childUpdates = ["/\(walkLocation.region_1depth_name)/\(walkLocation.region_2depth_name)/\(key)":["id":"\(id)"]]
        db.updateChildValues(childUpdates)
    }
    func loadProfileWalkingLocation(id : String, completion : @escaping (Document)->(Void)){
        db.child("Profile").child(id).child("WalkLocation").observeSingleEvent(of: .value) { snapshot in
            if !snapshot.hasChildren()  {
                //데이터가 없으면 해야할 행동
                print("don't have review data")
                return
            }
            do{
                let jsonData = try JSONSerialization.data(withJSONObject: snapshot.value!, options: [])
                let json = try JSONDecoder().decode(Document.self, from: jsonData)
                
                completion(json)
            }catch let error{
                print("parsed error --> \(error.localizedDescription)")
            }
        }
    }
    
    
    //MARK: - DogInfo
    func saveDogInfo(id : String,dogInfo : DogInfo){
        db.child("Profile").child(id).child("Dog").setValue(dogInfo.toDictionary)
    }
    func loadDogInfo(id : String, completion : @escaping (DogInfo)->(Void)){
        db.child("Profile").child(id).child("Dog").observeSingleEvent(of: .value) { snapshot in
            if !snapshot.hasChildren()  {
                //데이터가 없으면 해야할 행동
                print("don't have review data")
                return
            }
            do{
                let jsonData = try JSONSerialization.data(withJSONObject: snapshot.value!, options: [])
                let json = try JSONDecoder().decode(DogInfo.self, from: jsonData)
                
                completion(json)
            }catch let error{
                print("parsed error --> \(error.localizedDescription)")
            }
        }
    }
    func saveDogImages(id : String,images : DogImages){
        db.child("Profile").child(id).child("DogImages").setValue(images.toDictionary)
    }
    func loadDogImages(id : String,completion : @escaping (DogImages)->(Void)){
        db.child("Profile").child(id).child("DogImages").observeSingleEvent(of: .value) { snapshot in
            if !snapshot.hasChildren()  {
                //데이터가 없으면 해야할 행동
                print("don't have review data")
                return
            }
            do{
                let jsonData = try JSONSerialization.data(withJSONObject: snapshot.value!, options: [])
                let json = try JSONDecoder().decode(DogImages.self, from: jsonData)
                completion(json)
            }catch let error{
                print("parsed error --> \(error.localizedDescription)")
            }
        }
    }
    
    //MARK: -Owner Info
    func saveOwnerInfo(id : String,ownerInfo : OwnerInfo){
        db.child("Profile").child(id).child("Owner").setValue(ownerInfo.toDictionary)
    }
    func loadOwnerInfo(id : String, completion : @escaping (OwnerInfo)->(Void)){
        db.child("Profile").child(id).child("Owner").observeSingleEvent(of: .value) { snapshot in
            if !snapshot.hasChildren()  {
                //데이터가 없으면 해야할 행동
                print("don't have review data")
                return
            }
            do{
                let jsonData = try JSONSerialization.data(withJSONObject: snapshot.value!, options: [])
                let json = try JSONDecoder().decode(OwnerInfo.self, from: jsonData)
                
                completion(json)
            }catch let error{
                print("parsed error --> \(error.localizedDescription)")
            }
        }
    }
    func saveOwnerImages(id : String, images : OwnerImages){
        db.child("Profile").child(id).child("OwnerImages").setValue(images.toDictionary)
    }
    func loadOwnerImages(id : String, completion : @escaping (OwnerImages)->(Void)){
        db.child("Profile").child(id).child("OwnerImages").observeSingleEvent(of: .value) { snapshot in
            if !snapshot.hasChildren()  {
                //데이터가 없으면 해야할 행동
                print("don't have review data")
                return
            }
            do{
                let jsonData = try JSONSerialization.data(withJSONObject: snapshot.value!, options: [])
                let json = try JSONDecoder().decode(OwnerImages.self, from: jsonData)
                
                completion(json)
            }catch let error{
                print("parsed error --> \(error.localizedDescription)")
            }
        }
    }
    
    //MARK: - 메인, 등록된 유저정보 불러오기
    func loadAroundUserId(region : Document, completion : @escaping ([AroundUserId])->(Void)){
        db.child("\(region.region_1depth_name)").child("\(region.region_2depth_name)").observeSingleEvent(of: .value) { snapshot in
            if !snapshot.hasChildren()  {
                //데이터가 없으면 해야할 행동
                print("don't have review data")
                return
            }
            
            let dict = snapshot.value! as? [String:Any] ?? [:]
            var aroundDog = [Any]()
            
            for key in dict.keys {
                aroundDog.append(dict[key]!)
            }
            do{
                let jsonData = try JSONSerialization.data(withJSONObject: aroundDog, options: [])
                let json = try JSONDecoder().decode([AroundUserId].self, from: jsonData)
                completion(json)
            }catch let error{
                print("parsed error --> \(error.localizedDescription)")
            }
        }
    }
    
    func loadAroundUserInfo(id : String){
        
        db.child("Profile").child("\(id)").observeSingleEvent(of: .value) { snapshot in
            if !snapshot.hasChildren()  {
                //데이터가 없으면 해야할 행동
                print("don't have review data")
                return
            }
            do{
                let jsonData = try JSONSerialization.data(withJSONObject: snapshot.value!, options: [])
                let test = String(data: jsonData, encoding: String.Encoding.utf8)
                print("test --> \(test)")
//                let json = try JSONDecoder().decode(Profile.self, from: jsonData)
//                print("json --> \(json)")
            }catch let error{
                print("parsed error --> \(error.localizedDescription)")
            }
        }
        
    }
}
