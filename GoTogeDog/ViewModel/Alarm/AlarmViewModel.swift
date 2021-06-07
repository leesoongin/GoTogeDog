//
//  AlarmViewModel.swift
//  GoTogeDog
//
//  Created by 이숭인 on 2021/05/09.
//

import UIKit

class AlarmViewModel {
    static let shared = AlarmViewModel()
    
    var requestedMate : [AroundUserCard] = [AroundUserCard]()
    
   
    
    func addRequestMate(profile : Profile,id : String){
        let userCard = AroundUserCard(id: id, profile: profile)
        self.requestedMate.append(userCard)
    }
    
    func clearRequestMate(){
        self.requestedMate.removeAll()
    }
    
    func sortRequestMate(){
        self.requestedMate = self.requestedMate.sorted(by: { $0.id > $1.id })
    }
}
