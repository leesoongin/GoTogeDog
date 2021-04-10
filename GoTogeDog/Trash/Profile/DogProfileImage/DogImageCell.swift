//
//  DogImageCell.swift
//  GoTogeDog
//
//  Created by 이숭인 on 2021/03/26.
//

import UIKit

class DogImageCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override init(frame : CGRect){
        super.init(frame: frame)
        setup()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup(){
      
    }
}
