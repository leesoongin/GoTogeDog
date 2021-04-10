//
//  CharacterViewModel.swift
//  GoTogeDog
//
//  Created by 이숭인 on 2021/03/25.
//

import UIKit

class CharacterViewModel {
    static let shared = CharacterViewModel()
    
    var characterList : [String] = ["# 귀여운 ","# 애교만땅 ","# 겁이 많아요 ",
                                    "# 중성화 O","# 뭐라할까요ㅋㅋ","# 아이고오오어어",
                                    "# 너무많은데?","# 산책을 좋아해","# 쉬를 잘싼다.",
                                    "# 나이가 많아요","# 친구를 좋아해요","# 소형견이에요",
                                    "# 대형견이에요","# 사교성이 좋아요","# 소형견",
                                    "# 대형견","# 강아지 특징","# 친화력 짱",
                                    "# 아이고 쓸게없네","# 애교쟁이","# 겁이 많아요",
                                    "# 나이가 많아요","# 물어요","# ㅋㅋㅋㅋㅋㅋ",
                                    "# 밥을 잘 먹어요","# 다이어트중이에요"
                                    ]
    
    var characters : [String] = [String]()
    
    func addCharacter(character : String){
        if characters.contains(character){
            return
        }else{
            characters.append(character)
        }
    }
    
    func clearCharacters(){
        self.characters.removeAll()
    }
    
    var charactersToDictionary : [String : Any] {
        let dict : [String : Any] = ["characters":self.characters]
        return dict
    }
}
