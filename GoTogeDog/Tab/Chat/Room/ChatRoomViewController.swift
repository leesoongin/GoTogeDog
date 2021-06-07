//
//  ChatRoomViewController.swift
//  GoTogeDog
//
//  Created by 이숭인 on 2021/05/17.
//

import UIKit

class ChatRoomViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.dataSource = self
            tableView.delegate = self
            tableView.separatorStyle = .none
            
        }
    }
    @IBOutlet weak var destinationNameLabel: UILabel!
    @IBOutlet weak var inputMessageTextView: UITextView!{
        didSet{
            inputMessageTextView.delegate = self
        }
    }
    @IBOutlet weak var viewBottomMargin: NSLayoutConstraint!
    @IBOutlet weak var inputMessageTextViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableViewBottomMargin: NSLayoutConstraint!
   
    let chatRoomViewModel = ChatRoomViewModel.shared
    let firebaseManager = FirebaseManager.shared
    let userInfoManager = UserInfoManager.shared
    
    private var chatRoomData : ChatRoom?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "MyCell", bundle: nil), forCellReuseIdentifier: "myCell")
        tableView.register(UINib(nibName: "YourCell", bundle: nil), forCellReuseIdentifier: "yourCell")
        
        addNotification()
        initItem()
        
    }
    
    func initItem(){
        chatRoomViewModel.clearMessages()
    }
    
    func addNotification(){
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(getChatData), name: Notification.Name.getChatData, object: nil)
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        guard let id = userInfoManager.userInfo["id"] else { return }
        chatRoomViewModel.addMessages(userId : id, message: inputMessageTextView.text)
        inputMessageTextView.text = ""
        inputMessageTextViewHeight.constant = 40
        let lastIndexPath = IndexPath(row: chatRoomViewModel.messages.count - 1, section: 0)
        tableView.insertRows(at: [lastIndexPath], with: UITableView.RowAnimation.automatic)
        tableView.scrollToRow(at: lastIndexPath, at: UITableView.ScrollPosition.bottom
                              , animated: true)
        
        //MARK: - 보낼때 내 채팅방 매세지랑 상대방 채팅방 메세지에 저장하자
        firebaseManager.saveSendMessage(destinationId: chatRoomData!.destinationId, nickName: chatRoomData!.partnerName, messageDatas:chatRoomViewModel.messagesToDictionary())
        
    }
    @objc func getChatData(noti : Notification){
        self.chatRoomData = noti.object as! ChatRoom
        self.destinationNameLabel.text = chatRoomData?.partnerName
        chatRoomViewModel.clearMessages()
        firebaseManager.loadMessages(destinationId: chatRoomData!.destinationId) { response in
            self.chatRoomViewModel.extendMessages(messages: response.messages)
            self.tableView.reloadData()
        }//manager
    }
    
    @objc func keyboardWillShow(noti : Notification){
        
        let notiInfo = noti.userInfo!
        let keyboardFrame = notiInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        let height = keyboardFrame.size.height - self.view.safeAreaInsets.bottom
        let lastIndexPath = IndexPath(row: self.chatRoomViewModel.messages.count - 1, section: 0)
        let animationDuration = notiInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        
        UIView.animate(withDuration: animationDuration) {
            self.viewBottomMargin.constant = height
            self.view.layoutIfNeeded()
            if self.chatRoomViewModel.messages.count > 0{
                self.tableView.scrollToRow(at: lastIndexPath, at: UITableView.ScrollPosition.bottom
                                      , animated: false)
            }
        }
    }
    @objc func keyboardWillHide(noti : Notification){
        let notiInfo = noti.userInfo!
        let animationDuration = notiInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        
        UIView.animate(withDuration: animationDuration) {
            self.viewBottomMargin.constant = 0
            self.view.layoutIfNeeded()
        }
        
    }
}

extension ChatRoomViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatRoomViewModel.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = userInfoManager.userInfo["id"]
        
        if chatRoomViewModel.messages[indexPath.row].userId == id{
            guard let myCell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as? MyCell else {
                return UITableViewCell()
            }
            myCell.myTextView.text = chatRoomViewModel.messages[indexPath.row].message
            myCell.timeLabel.text = chatRoomViewModel.messages[indexPath.row].time
            myCell.selectionStyle = .none
            return myCell
        }else{
            guard let yourCell = tableView.dequeueReusableCell(withIdentifier: "yourCell", for: indexPath) as? YourCell else {
                return UITableViewCell()
            }
            yourCell.yourTextView.text = chatRoomViewModel.messages[indexPath.row].message
            yourCell.timeLabel.text = chatRoomViewModel.messages[indexPath.row].time
            yourCell.selectionStyle = .none
            return yourCell
        }

    }
    
    
}
extension ChatRoomViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //딱히 없음
        
    }
}

extension ChatRoomViewController : UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        if textView.contentSize.height <= 40 {
            inputMessageTextViewHeight.constant = 40
        }else if textView.contentSize.height >= 100 {
            inputMessageTextViewHeight.constant = 100
        }else{
            inputMessageTextViewHeight.constant = textView.contentSize.height
        }
    }
}
