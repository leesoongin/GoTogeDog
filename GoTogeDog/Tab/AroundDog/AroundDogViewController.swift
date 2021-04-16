//
//  ViewController.swift
//  GoTogeDog
//
//  Created by 이숭인 on 2021/03/15.
//

import UIKit

class AroundDogViewController: UIViewController {
   
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var addressLabel: UILabel!
    
    let aroundDogViewModel = AroundDogViewModel.shared
    let firebaseManager = FirebaseManager.shared
    let userInfoManager = UserInfoManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
         initViews()
        firebaseManager.loadProfileWalkingLocation(id: userInfoManager.userInfo["id"]!) { response in
            self.firebaseManager.loadAroundUserId(region: response) { users in
                for user in users{
                    self.firebaseManager.loadAroundUserInfo(id: user.id) { response in
                        //받아온 유저들의 정보를 list형태로 저장
                        let card = AroundUserCard(id: user.id, profile: response)
                        self.aroundDogViewModel.addCard(card: card)
                        
                        if user.id == users.last?.id{ // 마지막 데이터 로드라면 데이터 reload
                            self.collectionView.reloadData()
                            print("---> \(self.aroundDogViewModel.userCards)")
                        }
                    }
                }
            }
            DispatchQueue.main.async {
                self.addressLabel.text = response.region_1depth_name +
                    " " + response.region_2depth_name
                print("\(self.addressLabel.text)")
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    func initViews(){
        addressLabel.layer.cornerRadius = 10
    }
}

extension AroundDogViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //이 지역에 등록된 유저의 수만큼 return
        return self.aroundDogViewModel.userCards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dogCell", for: indexPath) as? DogCell else {
            return UICollectionViewCell()
        }
        let data = self.aroundDogViewModel.userCards[indexPath.row]
        cell.configure(dogName: data.profile.Dog.name, kind: data.profile.Dog.kind, dogAge: data.profile.Dog.age, address: data.profile.WalkLocation.address_name, dogImageUrl: data.profile.DogImages.imageUrls.first!)
        
        return cell
    }
}

extension AroundDogViewController : UICollectionViewDelegate {
    //터치시 상세화면으로 이동
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "AroundCardDetail", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! AroundCardDetailViewController
        presentPanModal(vc)

        NotificationCenter.default.post(name: NSNotification.Name.getUserCard, object: self.aroundDogViewModel.userCards[indexPath.row])
    }
}


extension AroundDogViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSpacing : CGFloat = 16
        let margin : CGFloat = 16
        let width : CGFloat = (collectionView.bounds.width-itemSpacing - margin*2)
        let height : CGFloat = width
        
        print("width -> \(width) , heifght -> \(height)")
        return CGSize(width: width, height: height)
    }
}
