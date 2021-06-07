//
//  AlarmCell.swift
//  GoTogeDog
//
//  Created by 이숭인 on 2021/05/04.
//

import UIKit
import Kingfisher

class AlarmCell: UITableViewCell {
    @IBOutlet weak var requestLabel: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(nicName : String,imageUrl : String){
        let url : URL = URL(string: imageUrl)!
        self.requestLabel.text = "\(nicName) 님이 메이트 요청을 보냈습니다."
        self.profileImage.kf.setImage(with: url)
    }
    func initViews(){
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = 10
    }
}
