//
//  DetailViewController.swift
//  GoTogeDog
//
//  Created by 이숭인 on 2021/04/13.
//

import UIKit
import PanModal
import Kingfisher

class AlarmDetailViewController: UIViewController {
    
   
    @IBOutlet weak var addressNameLabel: UILabel!
    // dogInfo
    @IBOutlet weak var dogImageView: UIImageView!
    @IBOutlet weak var dogNameLabel: UILabel!
    @IBOutlet weak var dogAgeLabel: UILabel!
    @IBOutlet weak var dogKindLabel: UILabel!
    
    //ownerInfo
    @IBOutlet weak var ownerNickNameLabel: UILabel!
    @IBOutlet weak var ownerImageView: UIImageView!
    @IBOutlet weak var ownerGenderLabel: UILabel!
    @IBOutlet weak var ownerAgeLabel: UILabel!
    @IBOutlet weak var ownerIntroduceTextView: UITextView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    let detailViewModel = AroundCardDetailViewModel.shared
    let firebaseManager = FirebaseManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //어떤게 클릭됬는지를 넘겨줘야겠네
        addNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        initViews()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        removeNotification()
    }
    func initViews(){
        DispatchQueue.main.async {
            self.dogImageView.kf.setImage(with: URL(string: (self.detailViewModel.userCard?.profile.DogImages.imageUrls.first)!))
            self.ownerImageView.kf.setImage(with: URL(string: (self.detailViewModel.userCard?.profile.OwnerImages.imageUrls.first)!))
        }
        addressNameLabel.text = detailViewModel.userCard?.profile.WalkLocation.address_name
        
        dogNameLabel.text = detailViewModel.userCard?.profile.Dog.name
        dogAgeLabel.text = detailViewModel.userCard?.profile.Dog.age
        dogKindLabel.text = detailViewModel.userCard?.profile.Dog.kind
        
        ownerNickNameLabel.text = detailViewModel.userCard?.profile.Owner.nickName
        ownerAgeLabel.text = detailViewModel.userCard?.profile.Owner.age
        ownerGenderLabel.text = detailViewModel.userCard?.profile.Owner.gender
        ownerIntroduceTextView.text = detailViewModel.userCard?.profile.Owner.introduce
        
        dogImageView.layer.cornerRadius = 10
        ownerImageView.layer.cornerRadius = 10
    }
    
    func addNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(getUserCardInfo(notification:)), name: Notification.Name.getUserCard, object: nil)
    }
    func removeNotification(){
        NotificationCenter.default.removeObserver(self, name: Notification.Name.getUserCard, object: nil)
    }
    
    @objc func getUserCardInfo(notification : NSNotification){
        let userCard = notification.object as! AroundUserCard
        self.detailViewModel.fetchUserCard(userCard: userCard)
    }
    
   
    @IBAction func acceptMateRequest(_ sender: Any) {
        acceptAlert()
    }
    
    @IBAction func cancelMateRequest(_ sender: Any) {
        cancelAlert()
    }
    
    func acceptAlert(){
        let alert = UIAlertController(title: "메이트 신청", message: "정말로 수락하실건가요?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (ok) in
            //MARK: - 대화방 생성하기
            let destinationId = self.detailViewModel.userCard?.id
            let nickName = self.detailViewModel.userCard?.profile.Owner.nickName
            self.firebaseManager.createChatRoom(destinationId: destinationId!,nickName : nickName!)
            self.mateAcceptAlert()
        }
        let cancel = UIAlertAction(title: "cancel", style: .cancel) { (cancel) in }
        alert.addAction(cancel)
        alert.addAction(ok)
        
        self.present(alert, animated: true, completion: nil)
    }
    func cancelAlert(){
        let alert = UIAlertController(title: "메이트 신청", message: "정말로 거절하실건가요?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (ok) in
            
        }
        let cancel = UIAlertAction(title: "cancel", style: .cancel) { (cancel) in }
        alert.addAction(cancel)
        alert.addAction(ok)
        
        self.present(alert, animated: true, completion: nil)
    }
    func mateAcceptAlert(){
        let alert = UIAlertController(title: "메이트 매칭", message: "매칭이 완료되었습니다!\n상대방과 대화를 나눠보세요!", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (ok) in
           
        }
        let cancel = UIAlertAction(title: "cancel", style: .cancel) { (cancel) in }
        alert.addAction(cancel)
        alert.addAction(ok)
        
        self.present(alert, animated: true, completion: nil)
    }
}

extension AlarmDetailViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.detailViewModel.userCard?.profile.Dog.characters.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "characterCell", for: indexPath) as? CharacterCell else {
            return UICollectionViewCell()
        }
        cell.configure(name: self.detailViewModel.userCard?.profile.Dog.characters[indexPath.row])
        
        return cell
    }
}

extension AlarmDetailViewController : UICollectionViewDelegate {
    
}

extension AlarmDetailViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSpacing : CGFloat = 16
        let margin : CGFloat = 8
        let width : CGFloat = (collectionView.bounds.width-itemSpacing - margin*2) / 2
        let height : CGFloat = 38

        return CGSize(width: width, height: height)
    }
}

//MARK: - panModal Presentable
extension AlarmDetailViewController : PanModalPresentable {
    var panScrollable: UIScrollView? {
            return nil
        }
    
    //펼쳐진 상태
    var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(0)
    }
    //true -> 최상단까지 펼쳐지지 않음 , false -> 최상단까지 펼쳐짐
    var anchorModalToLongForm: Bool {
        return false
    }
}

