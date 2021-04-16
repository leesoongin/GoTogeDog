//
//  AroundUserCard.swift
//  GoTogeDog
//
//  Created by 이숭인 on 2021/04/12.
//

import UIKit

struct AroundUserCard: Codable {
    var id : String
    var profile : Profile
    
    init(id : String, profile : Profile){
        self.id = id
        self.profile = profile
    }
}
