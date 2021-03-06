//
//  ChatRoomCell.swift
//  GoTogeDog
//
//  Created by 이숭인 on 2021/05/17.
//

import UIKit
import Kingfisher
class ChatRoomCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.profileImageView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(name: String){
        self.nameLabel.text = name
    }
}
