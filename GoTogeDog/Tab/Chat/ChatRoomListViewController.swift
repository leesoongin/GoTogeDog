//
//  ChatViewController.swift
//  GoTogeDog
//
//  Created by 이숭인 on 2021/03/15.
//

import UIKit

class ChatRoomListViewController: UIViewController {
    
    let firebaseManager = FirebaseManager.shared
    let chatRoomListViewModel = ChatRoomListViewModel.shared
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "ChatRoomCell", bundle: nil), forCellReuseIdentifier: "chatRoomCell")
        
        
    }//viewDidLoad
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        chatRoomListViewModel.clearRooms()
        firebaseManager.loadChatRoomList { response in
            for item in response{
                self.chatRoomListViewModel.addRoom(room: item)
                let lastIndexPath = IndexPath(row: self.chatRoomListViewModel.rooms.count - 1, section: 0)
                self.tableView.insertRows(at: [lastIndexPath], with: UITableView.RowAnimation.automatic)
            }//for
        }//manager
        print("나옴??")
    }
}

extension ChatRoomListViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatRoomListViewModel.rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "chatRoomCell", for: indexPath) as? ChatRoomCell else {
            return UITableViewCell()
        }
        cell.configure(name: chatRoomListViewModel.rooms[indexPath.row].partnerName)
        
        return cell
    }
}

extension ChatRoomListViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //나중에 인덱스패스로 정보 넘기자
        let storyboard = UIStoryboard(name: "Room", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! ChatRoomViewController
        present(vc, animated: true, completion: nil)
        
        NotificationCenter.default.post(name: NSNotification.Name.getChatData, object: self.chatRoomListViewModel.rooms[indexPath.row])
    }
}



