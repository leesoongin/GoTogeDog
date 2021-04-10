//
//  WalkingLocationViewController.swift
//  GoTogeDog
//
//  Created by 이숭인 on 2021/03/19.
//

import UIKit
import PanModal
import CoreLocation
import NMapsMap

class WalkingLocationViewController: MapViewController {
    //UI
    @IBOutlet weak var headView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var walkPoint: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var setAddressButton: UIButton!
    
    var locationManager = CLLocationManager()
    let firebaseManager = FirebaseManager.shared
    let userInfoManager = UserInfoManager.shared
    let walkLocationViewModel = WalkLoctionViewModel()
    
//    let walkingLocationViewModel = WalkingLocationViewModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !requestGPSPermission(){
            locationManager.requestAlwaysAuthorization()
        }
       
        initViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //TODO: 일단 지금은 내 위치를 default로 ! firebase 연동하면 그때 저장되있는거 불러오기, 아직 처음이라면 내 위치로.
        let param = RegioncodeParam(x: "\(mapView.locationOverlay.location.lng)", y: "\(mapView.locationOverlay.location.lat)")
        
        KakaoAPIManager().requestRegioncode(param: param) { response in
            self.walkLocationViewModel.setWalkLocation(walkLocation: response.documents.first!)
            DispatchQueue.main.async {
                self.addressLabel.text = response.documents.first?.address_name
            }
        }
    }
    
    func initViews(){
        headView.layer.cornerRadius = 10
        headView.layer.masksToBounds = true
        headView.layer.shadowOpacity = 0.4
        headView.layer.shadowOffset = CGSize(width: 0.3, height: 1.0)
        headView.layer.shadowRadius = 2.0
        headView.layer.masksToBounds = false
        
        bottomView.layer.cornerRadius = 15
        bottomView.layer.masksToBounds = true
        bottomView.layer.shadowOpacity = 0.4
        bottomView.layer.shadowOffset = CGSize(width: 0.3, height: 1.0)
        bottomView.layer.shadowRadius = 2.0
        bottomView.layer.masksToBounds = false
        
        addressLabel.layer.cornerRadius = 10
        setAddressButton.layer.cornerRadius = 10
        
        mapView.positionMode = .compass
        mapView.addCameraDelegate(delegate: self)
        naverMapView.showLocationButton = true
    }
    
    func update(){
        let coord = mapView.projection.latlng(from: walkPoint.center)
        let param = RegioncodeParam(x: "\(coord.lng)", y: "\(coord.lat)")
        
        KakaoAPIManager().requestRegioncode(param: param) { response in
            self.walkLocationViewModel.setWalkLocation(walkLocation: response.documents.first!)
            DispatchQueue.main.async {
                self.addressLabel.text = response.documents.first?.address_name
            }
        }
    }
    
    func checkAlert(){
        let alert = UIAlertController(title: "주소 설정", message: "해당 위치를 선택하실건가요?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (ok) in
            let userInfo = self.userInfoManager.userInfo
            self.firebaseManager.saveProfileWalkLocation(id: userInfo["id"]!, walkLocation: self.walkLocationViewModel.walkLocation!)
            self.completeAlert()
        }
        let cancel = UIAlertAction(title: "cancel", style: .cancel) { (cancel) in }
        alert.addAction(cancel)
        alert.addAction(ok)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func completeAlert(){
        let alert = UIAlertController(title: "주소 설정", message: "설정이 완료되었습니다.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (ok) in
            self.dismiss(animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "cancel", style: .cancel) { (cancel) in }
        alert.addAction(cancel)
        alert.addAction(ok)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func setAddress(_ sender: Any) {
        checkAlert()
    }
    
    func requestGPSPermission() -> Bool {
          switch CLLocationManager.authorizationStatus() {
          case .authorizedAlways, .authorizedWhenInUse:
            print("GPS: 권한 있음")
            return true
          case .restricted, .notDetermined:
            print("GPS: 아직 선택하지 않음")
            return false
          case .denied:
              print("GPS: 권한 없음")
            return false
          default:
              print("GPS: Default")
            return false
        }
    }
}

//MARK: - camera Delegate
extension WalkingLocationViewController : NMFMapViewCameraDelegate {
    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
        if animated {
            update()
        }
    }
}

//MARK: - panModal Presentable
extension WalkingLocationViewController : PanModalPresentable {
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


