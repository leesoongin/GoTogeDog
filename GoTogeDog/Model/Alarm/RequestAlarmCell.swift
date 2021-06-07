//
//  RequestAlarmCell.swift
//  GoTogeDog
//
//  Created by 이숭인 on 2021/05/09.
//

import UIKit

struct RequestAlarmCell: Codable {
    var id : String
    
    var toDictionary : [String:String]{
        let dict : [String : String] = ["id" : self.id]
        
        return dict
    }
}
