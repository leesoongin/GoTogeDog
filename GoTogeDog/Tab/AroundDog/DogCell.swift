//
//  dogCell.swift
//  GoTogeDog
//
//  Created by 이숭인 on 2021/04/05.
//

import UIKit
import Kingfisher

class DogCell: UICollectionViewCell {
   
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var kindLabel: UILabel!
    @IBOutlet var ageLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var container: UIView!
    
    override init(frame : CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func configure(name : String, kind : String, age : String, address : String, imageUrl : String){
        self.nameLabel.text = name
        self.kindLabel.text = kind
        self.ageLabel.text = age
        self.addressLabel.text = address
        self.imageView.kf.setImage(with: URL(string: imageUrl))
    }
    
    private func setup(){
        self.layer.cornerRadius = 10
    }
}
