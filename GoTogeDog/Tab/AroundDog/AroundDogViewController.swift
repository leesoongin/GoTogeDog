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
    // 프로필에 저장된 유저의 주소 depth_2 로 검색해와서 collectionView에다 채워넣자
    
    let firebaseManager = FirebaseManager.shared
    let userInfoManager = UserInfoManager.shared
    
    let dummyData : [DummyModel] = [
        DummyModel(name: "둥지1", age: "1", kind: "요크", address: "서울시 성북구 보문동", imageUrl: "https://firebasestorage.googleapis.com/v0/b/gotogedog.appspot.com/o/dogImages%2F1662466396%2F%3CUIImage:0x2825bc2d0%20anonymous%20%7B1410,%201411%7D%3E?alt=media&token=74e4c495-c5f6-4682-baed-ef57b688fc0b"),
        DummyModel(name: "둥지2", age: "2", kind: "요크", address: "서울시 성북구 숭인동", imageUrl: "https://firebasestorage.googleapis.com/v0/b/gotogedog.appspot.com/o/dogImages%2F1662466396%2F%3CUIImage:0x2825bc2d0%20anonymous%20%7B1410,%201411%7D%3E?alt=media&token=74e4c495-c5f6-4682-baed-ef57b688fc0b"),
        DummyModel(name: "둥지3", age: "3", kind: "요크", address: "서울시 성북구 안암동", imageUrl: "https://firebasestorage.googleapis.com/v0/b/gotogedog.appspot.com/o/dogImages%2F1662466396%2F%3CUIImage:0x2825bc2d0%20anonymous%20%7B1410,%201411%7D%3E?alt=media&token=74e4c495-c5f6-4682-baed-ef57b688fc0b"),
        DummyModel(name: "둥지4", age: "4", kind: "요크", address: "서울시 성북구 돈암동", imageUrl: "https://firebasestorage.googleapis.com/v0/b/gotogedog.appspot.com/o/dogImages%2F1662466396%2F%3CUIImage:0x2825bc2d0%20anonymous%20%7B1410,%201411%7D%3E?alt=media&token=74e4c495-c5f6-4682-baed-ef57b688fc0b"),
        DummyModel(name: "둥지5", age: "5", kind: "요크", address: "서울시 성북구 숭인1동", imageUrl: "https://firebasestorage.googleapis.com/v0/b/gotogedog.appspot.com/o/dogImages%2F1662466396%2F%3CUIImage:0x2825bc2d0%20anonymous%20%7B1410,%201411%7D%3E?alt=media&token=74e4c495-c5f6-4682-baed-ef57b688fc0b"),
        DummyModel(name: "둥지6", age: "6", kind: "요크", address: "서울시 성북구 숭인2동", imageUrl: "https://firebasestorage.googleapis.com/v0/b/gotogedog.appspot.com/o/dogImages%2F1662466396%2F%3CUIImage:0x2825bc2d0%20anonymous%20%7B1410,%201411%7D%3E?alt=media&token=74e4c495-c5f6-4682-baed-ef57b688fc0b")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
         initViews()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        firebaseManager.loadProfileWalkingLocation(id: userInfoManager.userInfo["id"]!) { response in
            self.firebaseManager.loadAroundUserId(region: response) { users in
                for user in users{
                    self.firebaseManager.loadAroundUserInfo(id: user.id) { response in
                        //여기서 뷰모델로 받아서 리스트 저장하고 띄우자. 휴!
                        print("user --> \(user) , response --> \(response)")
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
    
    
    func initViews(){
        addressLabel.layer.cornerRadius = 10
    }
}

extension AroundDogViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //이 지역에 등록된 유저의 수만큼 return
        return dummyData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dogCell", for: indexPath) as? DogCell else {
            return UICollectionViewCell()
        }
        let dummyData = self.dummyData[indexPath.row]
        cell.configure(name: dummyData.name, kind: dummyData.kind, age: dummyData.age, address: dummyData.address, imageUrl: dummyData.imageUrl)
        
        return cell
    }
}

extension AroundDogViewController : UICollectionViewDelegate {
    //터치시 상세화면으로 이동
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
