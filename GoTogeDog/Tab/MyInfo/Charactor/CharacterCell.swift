//
//  CharacterCell.swift
//  GoTogeDog
//
//  Created by 이숭인 on 2021/03/30.
//

import UIKit
import SnapKit

class CharacterCell: UICollectionViewCell {
    
    @IBOutlet weak var characterLabel: UILabel!
    
    func configure(name : String?){
        characterLabel.text = name
    }
    
    override init(frame : CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup(){
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        self.layer.borderColor =  #colorLiteral(red: 0.7528669238, green: 0.7706195712, blue: 0.9400042892, alpha: 1)
        
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.backgroundColor =  #colorLiteral(red: 0.9581701159, green: 0.9367547035, blue: 0.9787998796, alpha: 1)
               
            } else {
                self.backgroundColor = .white
                self.layer.borderWidth = 1
                self.layer.borderColor =  #colorLiteral(red: 0.7794443965, green: 0.7988916039, blue: 0.9459519982, alpha: 1)
               
            }
        }
    }

}

