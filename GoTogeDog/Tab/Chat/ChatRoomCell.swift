//
//  ChatRoomCell.swift
//  GoTogeDog
//
//  Created by 이숭인 on 2021/03/16.
//

import UIKit

class ChatRoomCell: UITableViewCell {

    @IBOutlet weak var profile_image: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
