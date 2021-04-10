//
//  MyInfoViewController.swift
//  GoTogeDog
//
//  Created by 이숭인 on 2021/03/29.
//

import UIKit
import YPImagePicker
import Kingfisher

class MyInfoViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
 
    @IBOutlet weak var dogImage: UIImageView!
    @IBOutlet weak var ownerImage: UIImageView!
    @IBOutlet weak var introTextView: UITextView!
    
    @IBOutlet weak var walkLocationLabel: UILabel!
    @IBOutlet weak var dogNameLabel: UILabel!
    @IBOutlet weak var dogKindLabel: UILabel!
    @IBOutlet weak var dogAgeLabel: UILabel!
    
    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var ownerGenderLabel: UILabel!
    @IBOutlet weak var ownerAgeLabel: UILabel!
    
    let characterViewModel = CharacterViewModel.shared
    let firebaseManager = FirebaseManager.shared
    let firebaseStorageManager = FirebaseStorageManager.shared
    let userInfoManager = UserInfoManager.shared
    
    var config = YPImagePickerConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config.library.maxNumberOfItems = 3
        
        initViews()
        collectionView.allowsMultipleSelection = true
    }
    
    func initViews(){
        //dog, owner값 디비에서 꺼내와서 디폴트값으로 정해놓자.
        dogImage.layer.cornerRadius = 10
        ownerImage.layer.cornerRadius = 10
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadProfileInfo()
    }
    
    func loadProfileInfo(){
        loadDogInfo()
        loadDogImage()
        loadOwnerInfo()
        loadOwnerImage()
        loadWalkLocation()
    }
    
    func loadDogInfo(){
        let userInfo = userInfoManager.userInfo
        firebaseManager.loadDogInfo(id: userInfo["id"]!) { response in
            DispatchQueue.main.async {
                self.dogNameLabel.text = response.name
                self.dogKindLabel.text = response.kind
                self.dogAgeLabel.text = response.age
                for character in response.characters {
                    self.characterViewModel.addCharacter(character: character)
                }
                self.collectionView.reloadData()
            }
        }
    }
    func loadDogImage(){
        let userInfo = userInfoManager.userInfo
        firebaseManager.loadDogImages(id: userInfo["id"]!) { response in
            DispatchQueue.main.async {
                let url = URL(string: response.imageUrls.first!)
                self.dogImage.kf.setImage(with: url)
            }
        }
    }
    
    func loadOwnerInfo(){
        let userInfo = userInfoManager.userInfo
        firebaseManager.loadOwnerInfo(id: userInfo["id"]!) { response in
            self.ownerNameLabel.text = response.nickName
            self.ownerGenderLabel.text = response.gender
            self.ownerAgeLabel.text = response.age
            self.introTextView.text = response.introduce
        }
    }
    func loadOwnerImage(){
        let userInfo = userInfoManager.userInfo
        firebaseManager.loadOwnerImages(id: userInfo["id"]!) { response in
            DispatchQueue.main.async {
                let url = URL(string: response.imageUrls.first!)
                self.ownerImage.kf.setImage(with: url)
            }
        }
    }
    
    func loadWalkLocation(){
        let userInfo = userInfoManager.userInfo
        
        firebaseManager.loadProfileWalkingLocation(id: userInfo["id"]!) { response in
            DispatchQueue.main.async {
                self.walkLocationLabel.text = response.address_name
            }
        }
    }
    
    func selectPhoto(flag : Int){
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, cancelled in
            if cancelled {
                picker.dismiss(animated: true, completion: nil)
                return
            }
            if flag == 0 {
                if let photo = items.singlePhoto {
                    self.firebaseStorageManager.uploadDogImages(id: self.userInfoManager.userInfo["id"]!, image: photo.image) { responseUrl in
                        self.completeAlert(flag: flag)
                        var dogImages = DogImages()
                        dogImages.addUrl(url:responseUrl)
                        self.firebaseManager.saveDogImages(id: self.userInfoManager.userInfo["id"]!, images: dogImages)
                    }
                }
            }else{
                if let photo = items.singlePhoto {
                    self.firebaseStorageManager.uploadOwnerImages(id: self.userInfoManager.userInfo["id"]!, image: photo.image) { responseUrl in
                        self.completeAlert(flag: flag)
                        var ownerImages = OwnerImages()
                        ownerImages.addUrl(url: responseUrl)
                        self.firebaseManager.saveOwnerImages(id: self.userInfoManager.userInfo["id"]!, images: ownerImages)
                    }
                }
            }
            
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
    
    func checkAlert(flag : Int){
        let alert = UIAlertController(title: "프로필 사진 수정", message: "사진을 수정하실건가요?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (ok) in
            self.selectPhoto(flag: flag)
        }
        let cancel = UIAlertAction(title: "cancel", style: .cancel) { (cancel) in }
        alert.addAction(cancel)
        alert.addAction(ok)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func completeAlert(flag : Int){
        let alert = UIAlertController(title: "사진 업로드", message: "프로필 사진 업로드 완료", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (ok) in
            if flag == 0 {
                self.loadDogImage()
            }else{
                self.loadOwnerImage()
            }
        }
        let cancel = UIAlertAction(title: "cancel", style: .cancel) { (cancel) in }
        alert.addAction(cancel)
        alert.addAction(ok)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func editWalkLocation(_ sender: Any) {
        let storyboard = UIStoryboard(name: "WalkingLocation", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! WalkingLocationViewController
        presentPanModal(vc)
    }
    @IBAction func editDogInfo(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Character", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! CharacterViewController
        presentPanModal(vc)
    }
    
    @IBAction func editOwnerInfo(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Introduce", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! IntroduceViewController
        presentPanModal(vc)
    }
    
    @IBAction func editDogImage(_ sender: Any) {
        let flag = 0
        checkAlert(flag: flag)
    }
    
    @IBAction func editOwnerImage(_ sender: Any) {
        let flag = 1
        checkAlert(flag: flag)
    }
    
    @IBAction func tapGesture(_ sender: Any) {
        introTextView.resignFirstResponder()
    }
}

extension MyInfoViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characterViewModel.characters.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "characterCell", for: indexPath) as? CharacterCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(name: characterViewModel.characters[indexPath.row])
        
        return cell
    }
}

extension MyInfoViewController : UICollectionViewDelegate {

}

extension MyInfoViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSpacing : CGFloat = 16
        let margin : CGFloat = 8
        let width : CGFloat = (collectionView.bounds.width-itemSpacing - margin*2) / 2
        let height : CGFloat = 38

        return CGSize(width: width, height: height)
    }
}
