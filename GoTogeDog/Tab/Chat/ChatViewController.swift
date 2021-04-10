//
//  ChatViewController.swift
//  GoTogeDog
//
//  Created by 이숭인 on 2021/03/15.
//

import UIKit

class ChatViewController: UIViewController {
    //dummy
    var dummyData = [ChatRoom]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let image : UIImage = UIImage(named: "dog2")!
        dummyData.append(ChatRoom(profile_image_path: image, nickName: "이숭인", lastMessage: "ㅋㅋㅋ마지막 메세지 ~~"))
        dummyData.append(ChatRoom(profile_image_path: image, nickName: "송정훈", lastMessage: "ㅋㅋㅋ마지막 메세지 ~~"))
        dummyData.append(ChatRoom(profile_image_path: image, nickName: "이재웅", lastMessage: "ㅋㅋㅋ마지막 메세지 ~~"))
        dummyData.append(ChatRoom(profile_image_path: image, nickName: "이하연", lastMessage: "ㅋㅋㅋ마지막 메세지 ~~"))
    }
    
    @IBAction func moveToProfile(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let vc = storyboard.instantiateInitialViewController()
        vc?.modalPresentationStyle = .fullScreen
        present(vc!, animated: false, completion: nil)
    }
}

extension ChatViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "chatRoomCell", for: indexPath) as? ChatRoomCell else {
            return UITableViewCell()
        }
        
        cell.profile_image.image = dummyData[indexPath.row].profile_image_path
        cell.profile_image.clipsToBounds = true
        cell.profile_image.layer.cornerRadius = 10
        cell.nameLabel.text = dummyData[indexPath.row].nickName
        cell.lastMessageLabel.text = dummyData[indexPath.row].lastMessage
        
        return cell
    }
    
    
}

extension ChatViewController : UITableViewDelegate {
    
}
