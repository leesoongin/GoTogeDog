//
//  WalkingLocationViewModel.swift
//  GoTogeDog
//
//  Created by 이숭인 on 2021/03/19.
//

import UIKit

class WalkingLocationViewModel {
    static let shared = WalkingLocationViewModel()
    
    var location : Regioncode?
    
    var address : String? {
        return self.location?.documents.first?.address_name
    }
    
    func setLocation(location : Regioncode){
        self.location = location
    }
    
    func reqeustRegioncode(param : RegioncodeParam,completion : @escaping (Regioncode)->(Void)){
        KakaoAPIManager().requestRegioncode(param: param) { response in
            completion(response)
        }
    }
}
