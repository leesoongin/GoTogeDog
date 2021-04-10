//
//  AroundDogViewModel.swift
//  GoTogeDog
//
//  Created by 이숭인 on 2021/04/05.
//

import UIKit

class AroundDogViewModel {
    // 1. 내 주소정보 알고있어야겠지?
    // 2. 내 주소 정보를 기반으로 그 주변의 유저 아이디를 받아와 저장 -> [String]
    // 3. 유저 아이디로 요청한 프로필 정보 가져오기 [Profile]
    var myAddress : String?
    var aroundUsersId : [String] = [String]()
    var usersProfile : [Profile] = [Profile]()
    
    
    
}
