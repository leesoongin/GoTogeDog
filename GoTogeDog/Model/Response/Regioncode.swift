//
//  Regioncode.swift
//  GoTogeDog
//
//  Created by 이숭인 on 2021/03/19.
//

import UIKit

struct Regioncode : Codable {
    let documents : [Document]
}

struct Document : Codable {
    let region_type : String
    let address_name : String
    let region_1depth_name : String
    let region_2depth_name : String
    let region_3depth_name : String
    let region_4depth_name : String
    //둘은 어디쓰일지 일단 모르겠음 ㅋㅅ
    let code : String
    let x : Double
    let y : Double
    
    var toDictionary : [String : Any] {
        let dict : [String : Any] = ["region_type":self.region_type,"address_name":self.address_name,
                                     "region_1depth_name":self.region_1depth_name,"region_2depth_name":self.region_2depth_name,
                                     "region_3depth_name":self.region_3depth_name,"region_4depth_name":self.region_4depth_name,
                                     "code":self.code,"x":self.x,"y":self.y]
        
        return dict
    }
}
