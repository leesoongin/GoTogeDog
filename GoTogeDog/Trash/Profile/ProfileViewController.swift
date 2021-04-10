////
////  ProfileViewController.swift
////  GoTogeDog
////
////  Created by 이숭인 on 2021/03/18.
////
//
//import UIKit
//import YPImagePicker
//
//class ProfileViewController: UIViewController {
//
//    @IBOutlet weak var headView: UIView!
//    @IBOutlet weak var upperView: UIView!
//    @IBOutlet weak var middleView: UIView!
//    @IBOutlet weak var bottomView: UIView!
//    
//    @IBOutlet weak var addressLabel: UILabel!
//    @IBOutlet weak var dog_name: UITextField!
//    @IBOutlet weak var dog_age: UITextField!
//    @IBOutlet weak var introduce: UITextView!
//    @IBOutlet weak var profileImageView: UIImageView!
//    
//    var config = YPImagePickerConfiguration()
//    var photoData : Data?
//    
//    let userInfoManager = UserInfoManager.shared
//    let firebaseManager = FirebaseManager.shared
//    let firebaseStorageManager = FirebaseStorageManager.shared
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        initViews()
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//        addNotification()
//    }
//
//    func initViews(){
//        //addressLabel은 db가 비었다면, default --> 위치를 설정해주세요! 지금은 테스트중이니까 일단은 default로 해놓자
//        addressLabel.text = "위치를 설정해주세요 !"
//        introduce.delegate = self
//        
//        headView.layer.cornerRadius = 10
//        headView.layer.masksToBounds = true
//        headView.layer.shadowOpacity = 0.4
//        headView.layer.shadowOffset = CGSize(width: 0.3, height: 1.0)
//        headView.layer.shadowRadius = 2.0
//        headView.layer.masksToBounds = false
//        
//        upperView.layer.cornerRadius = 10
//        middleView.layer.cornerRadius = 10
//        bottomView.layer.cornerRadius = 10
//      
//    }
//    
//    @IBAction func moveToWalkingLocation(_ sender: Any) {
//        let storyboard = UIStoryboard(name: "WalkingLocation", bundle: nil)
//        let vc = storyboard.instantiateInitialViewController() as! WalkingLocationViewController
//        presentPanModal(vc)
//    }
//    
//   
//    @IBAction func moveToDogProfileImage(_ sender: Any) {
//        let storyboard = UIStoryboard(name: "DogProfileImage", bundle: nil)
//        let vc = storyboard.instantiateInitialViewController() as! DogProfileImageViewController
//        presentPanModal(vc)
//    }
//    
//    @IBAction func moveToOnwerProfileImage(_ sender: Any) {
//        let storyboard = UIStoryboard(name: "OnwerImage", bundle: nil)
//        let vc = storyboard.instantiateInitialViewController() as! OnwerImageViewController
//        presentPanModal(vc)
//    }
//    
//    @IBAction func uploadProfile(_ sender: Any) {
//        fetchIntroduce()
//
//        dismiss(animated: true, completion: nil)
//        //내용 불러와서 디비에 저장하기
//    }
//    @IBAction func tabGesture(_ sender: Any) {
//        dog_name.resignFirstResponder()
//        dog_age.resignFirstResponder()
//        introduce.resignFirstResponder()
//    }
//    
//    func addNotification(){
//        NotificationCenter.default.addObserver(self, selector: #selector(fetchAddress), name: NSNotification.Name("address"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(fetchDogImages), name: NSNotification.Name("dogImages"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(fetchOnwerImages), name: NSNotification.Name("onwerImages"), object: nil)
//    }
//    
//    //fetch부분으로 받아온 값들을 프로필 모델값에 넣어 나중에 파이어베이스에 넣자
//    @objc func fetchAddress(notification : Notification){
//        addressLabel.text = ((notification.userInfo!["address"]) as! String)
//        profileViewModel.fetchAddress(address: notification.userInfo!["address"] as! String)
//    }
//    @objc func fetchDogImages(notification : Notification){
//        let images = notification.userInfo!["dogImages"] as! [Data]
//        profileViewModel.fetchDogImages(images: images)
//    }
//    @objc func fetchOnwerImages(notification : Notification){
//        let images = notification.userInfo!["onwerImages"] as! [Data]
//        print("images --> \(images)")
//        profileViewModel.fetchOwnerImages(images: images)
//    }
//    func fetchIntroduce(){
//        let introduce = self.introduce.text
//        profileViewModel.fetchIntroduce(introduce: introduce!)
//    }
//}
//
//extension ProfileViewController : UITextViewDelegate {
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        //올리고
//        self.view.frame.origin.y -= 300
//    }
//    
//    func textViewDidEndEditing(_ textView: UITextView) {
//        // 내리고 하면될듯?
//        self.view.frame.origin.y = 0
//    }
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        let currentText = textView.text ?? ""
//        guard let stringRange = Range(range, in: currentText) else { return false }
//        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
//     
//        return changedText.count <= 300
//    }
//}
//
//extension ProfileViewController : UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//}
//// 해야할거 !
//// 1. 키보드 노티피케이션, 글자수 제한 300자 정도로 하자 [o]
//// 2. 이미지 피커 --> YPImagePicker 라이브러리 사용해보자.
//// 3. 성격 collecionView Controller 만들어서 연동해놓자.
//// 4. 최종 적은 데이터를 파베 디비에 잘 넣어보자. --> model 하나 만들어서 넣으면 됨 ㅎㅎ
////    + 처음 화면킬때 디비에서 불러온 값으로 데이터 채워넣기 없다면 default값을 띄우기!
