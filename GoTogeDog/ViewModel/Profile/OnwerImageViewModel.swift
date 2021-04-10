//
//  OnwerImageViewModel.swift
//  GoTogeDog
//
//  Created by 이숭인 on 2021/03/28.
//

import UIKit

class OnwerImageViewModel {
    var images : [UIImage] = [UIImage]()

    var convertToData : [Data] {
        var data = [Data]()
        
        for image in images {
            data.append(image.jpegData(compressionQuality: 0.8)!)
        }
        
        return data
    }
    
    func addImage(image : UIImage){
        images.append(image)
    }
    
    var imagesToDictionary : [String : Any] {
        let dict : [String : Any] = ["onwerImages":self.convertToData]
        return dict
    }
}
