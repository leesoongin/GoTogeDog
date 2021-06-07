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
    
    func loadAroundUserInfo(id : String, completion : @escaping (Profile)->(Void)){
        db.child("Profile").child("\(id)").queryOrderedByKey().observeSingleEvent(of: .value) { snapshot in
            if !snapshot.hasChildren()  {
                //데이터가 없으면 해야할 행동
                print("don't have review data")
                return
            }
            
            let dict = snapshot.value! as? [String:Any] ?? [:]
            var dogs = [String : Any]()
            var ownerImages = [String : Any]()
            var owner = [String : Any]()
            var walkLocation = [String : Any]()
            var dogImages = [String : Any]()
            
            for key in dict.keys {
                switch key {
                case "Dog":
                    dogs = dict[key] as! [String : Any]
                case "OwnerImages":
                    ownerImages = dict[key] as! [String : Any]
                case "Owner":
                    owner = dict[key] as! [String : Any]
                case "WalkLocation":
                    walkLocation = dict[key] as! [String : Any]
                case "DogImages":
                    dogImages = dict[key] as! [String : Any]
                default:
                    print("나오면 앙대!")
                }
            }
            
            do{
                let dogJson = try JSONSerialization.data(withJSONObject: dogs, options: [])
                let ownerImagesJson = try JSONSerialization.data(withJSONObject: ownerImages, options: [])
                let ownerJson = try JSONSerialization.data(withJSONObject: owner, options: [])
                let walkLocationJson = try JSONSerialization.data(withJSONObject: walkLocation, options: [])
                let dogImagesJson = try JSONSerialization.data(withJSONObject: dogImages, options: [])
                
                let dogJsonData = try JSONDecoder().decode(DogInfo.self, from: dogJson)
                let ownerImagesJsonData = try JSONDecoder().decode(OwnerImages.self, from: ownerImagesJson)
                let ownerJsonData = try JSONDecoder().decode(OwnerInfo.self, from: ownerJson)
                let walkLocationJsonData = try JSONDecoder().decode(Document.self, from: walkLocationJson)
                let dogImagesJsonData = try JSONDecoder().decode(DogImages.self, from: dogImagesJson)
                
                let profile = Profile(walkLocation: walkLocationJsonData, dog: dogJsonData, dogImages: dogImagesJsonData, owner: ownerJsonData, ownerImages: ownerImagesJsonData)
                completion(profile)
            }catch let error{
                print("parsed error --> \(error.localizedDescription)")
            }
        }
    }
    func sendWalkingMate(id : String){
        guard let key = db.child("MateAlarm").child(id).childByAutoId().key else { return }
        
        let childUpdates = ["/MateAlarm/\(id)/\(key)" : ["id" : userInfoManager.userInfo["id"]] ]
        db.updateChildValues(childUpdates)
    }
    func loadWalkingMateId(completion : @escaping ([RequestAlarmCell])->(Void)){
        guard let id = userInfoManager.userInfo["id"] else { return }
        
        db.child("MateAlarm").child(id).queryOrderedByKey().observeSingleEvent(of: .value) { snapshot in
            if !snapshot.hasChildren()  {
                //데이터가 없으면 해야할 행동
                print("don't have review data")
                return
            }
            let dict = snapshot.value! as? [String : Any] ?? [:]
            var cells : [RequestAlarmCell] = [RequestAlarmCell]()
            do{
                for key in dict.keys {
                    let idJson = try JSONSerialization.data(withJSONObject: dict[key], options: [])
                    let idJsonData = try JSONDecoder().decode(RequestAlarmCell.self, from: idJson)
                    
                    cells.append(idJsonData)
                }
                completion(cells)
            }catch let error{
                print("parsed error --> \(error.localizedDescription)")
            }
        }
    }
    
    func loadWalkingMateInfo(requestedAlarm : [RequestAlarmCell],completion : @escaping ([AroundUserCard])->(Void)){
        var result : [AroundUserCard] = [AroundUserCard]()
        
        for item in requestedAlarm {
            db.child("Profile").child(item.id).queryOrderedByKey().observeSingleEvent(of: .value) { snapshot in
                if !snapshot.hasChildren()  {
                    //데이터가 없으면 해야할 행동
                    print("don't have review data")
                    return
                }
                
                let dict = snapshot.value! as? [String:Any] ?? [:]
                var dogs = [String : Any]()
                var ownerImages = [String : Any]()
                var owner = [String : Any]()
                var walkLocation = [String : Any]()
                var dogImages = [String : Any]()
                
                for key in dict.keys {
                    switch key {
                    case "Dog":
                        dogs = dict[key] as! [String : Any]
                    case "OwnerImages":
                        ownerImages = dict[key] as! [String : Any]
                    case "Owner":
                        owner = dict[key] as! [String : Any]
                    case "WalkLocation":
                        walkLocation = dict[key] as! [String : Any]
                    case "DogImages":
                        dogImages = dict[key] as! [String : Any]
                    default:
                        print("나오면 앙대!")
                    }
                }
                
                do{
                    let dogJson = try JSONSerialization.data(withJSONObject: dogs, options: [])
                    let ownerImagesJson = try JSONSerialization.data(withJSONObject: ownerImages, options: [])
                    let ownerJson = try JSONSerialization.data(withJSONObject: owner, options: [])
                    let walkLocationJson = try JSONSerialization.data(withJSONObject: walkLocation, options: [])
                    let dogImagesJson = try JSONSerialization.data(withJSONObject: dogImages, options: [])
                    
                    let dogJsonData = try JSONDecoder().decode(DogInfo.self, from: dogJson)
                    let ownerImagesJsonData = try JSONDecoder().decode(OwnerImages.self, from: ownerImagesJson)
                    let ownerJsonData = try JSONDecoder().decode(OwnerInfo.self, from: ownerJson)
                    let walkLocationJsonData = try JSONDecoder().decode(Document.self, from: walkLocationJson)
                    let dogImagesJsonData = try JSONDecoder().decode(DogImages.self, from: dogImagesJson)
                    
                    let profile = Profile(walkLocation: walkLocationJsonData, dog: dogJsonData, dogImages: dogImagesJsonData, owner: ownerJsonData, ownerImages: ownerImagesJsonData)
                    let id = item.id
                    let userCard = AroundUserCard(id: id, profile: profile)
                    //받아오기
                    result.append(userCard)
                }catch let error{
                    print("parsed error --> \(error.localizedDescription)")
                }
            }//snapshot
        }//for
    }//load
    
    func test(){
        let query = db.child("MateAlarm").child("1662466396").queryOrderedByKey()
        print(query)
    }
    
    func createChatRoom(destinationId : String,nickName : String){
        guard let id = userInfoManager.userInfo["id"] else { return }
        guard let destinationName = userInfoManager.userInfo["name"] else { return }
        guard let key = db.child("ChatRooms").child(id).childByAutoId().key else { return }
        let initMessage = Message(userId : "init",message: "init", time: "test", isMine: false)
        let room = ChatRoom(destinationId: destinationId, myId: id,partnerName : nickName,messages: [initMessage])
        let room2 = ChatRoom(destinationId: id, myId: destinationId, partnerName: destinationName,messages: [initMessage])
        
        db.child("ChatRooms").child(id).child(destinationId).setValue(room.toDictionary)
        db.child("ChatRooms").child(destinationId).child(id).setValue(room2.toDictionary)
    }
    
    func loadChatRoomList(completion : @escaping ([ChatRoom]) -> (Void)){
        guard let id = userInfoManager.userInfo["id"] else { return }
        db.child("ChatRooms").child(id).observeSingleEvent(of: .value) { snapshot in
            if !snapshot.hasChildren()  {
                //데이터가 없으면 해야할 행동
                print("don't have review data")
                return
            }
            do{
                let dict = snapshot.value! as? [String : Any] ?? [:]
                var rooms : [ChatRoom] = [ChatRoom]()
                do{
                    for key in dict.keys {
                        let idJson = try JSONSerialization.data(withJSONObject: dict[key], options: [])
                        let idJsonData = try JSONDecoder().decode(ChatRoom.self, from: idJson)
                        
                        rooms.append(idJsonData)
                    }
                    completion(rooms)
                }catch let error{
                    print("parsed error --> \(error.localizedDescription)")
                }
            }
        }
    }
    
    func saveSendMessage(destinationId : String, nickName : String, messageDatas :[[String : Any]] ){
        guard let id = userInfoManager.userInfo["id"] else { return }
        let childUpdates = ["/ChatRooms/\(id)/\(destinationId)/messages":messageDatas]
        db.updateChildValues(childUpdates)
        let destinationChildUpdates = ["/ChatRooms/\(destinationId)/\(id)/messages":messageDatas]
        db.updateChildValues(destinationChildUpdates)
    }
    func loadMessages(destinationId: String,completion : @escaping (ChatRoom)->(Void)){
        guard let id = userInfoManager.userInfo["id"] else { return }
        db.child("ChatRooms").child(id).child(destinationId).observeSingleEvent(of: .value) { snapshot in
            if !snapshot.hasChildren()  {
                //데이터가 없으면 해야할 행동
                print("don't have review data")
                return
            }
            do{
                let jsonData = try JSONSerialization.data(withJSONObject: snapshot.value!, options: [])
                let json = try JSONDecoder().decode(ChatRoom.self, from: jsonData)
                
                completion(json)
            }catch let error{
                print("parsed error --> \(error.localizedDescription)")
            }
        }
    }
}
