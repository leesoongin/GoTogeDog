//
//  AroundCardDetailViewModel.swift
//  GoTogeDog
//
//  Created by 이숭인 on 2021/04/15.
//

import UIKit

class AroundCardDetailViewModel {
    static let shared = AroundCardDetailViewModel()
    
    var userCard : AroundUserCard?
    
    func fetchUserCard(userCard : AroundUserCard){
        self.userCard = userCard
    }
}
