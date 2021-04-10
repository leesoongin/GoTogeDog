//
//  LoginViewController.swift
//  GoTogeDog
//
//  Created by 이숭인 on 2021/03/15.
//

import UIKit
import KakaoSDKUser
import KakaoSDKAuth
import Lottie

class LoginViewController: UIViewController {
    
    //Lottie AnimationView 생성
    let animationView = AnimationView(name:"Logo_Animation")
    let firebaseManager = FirebaseManager.shared
    let userInfoManager = UserInfoManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //메인 뷰에 삽입
        view.addSubview(animationView)
        view.backgroundColor =  #colorLiteral(red: 0.7962616086, green: 0.9422431588, blue: 0.7727558017, alpha: 1)
        animationView.frame = CGRect(x: 0, y: 0, width: 250, height: 250) // 애니메이션뷰의 크기 설정
        animationView.center = self.view.center // 애니메이션뷰의 위치설정
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 2.0
        animationView.loopMode = .loop
        //애니메이션 재생(애니메이션 재생모드 미 설정시 1회)
        animationView.play()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        //로그인 여부 확인 -> 유저정보 저장
        if AuthApi.hasToken() {
            //화면 이동
            self.moveToMainController()
        }
    }
    @IBAction func login(_ sender: Any) {
        //처음 로그인이라면, 1. UserDefault에 저장 2. firebaseDatabase에 저장
        AuthApi.shared.loginWithKakaoTalk {(oauthToken, error) in
            if let error = error {
                print(error)
            }
            else {
                self.animationView.pause()
                //fetch userInfo to firebaseManager
                self.registUserInfoToServer()
                self.moveToMainController()
            }
        }
    }
    
    func moveToMainController() {
        let storyboard = UIStoryboard(name: "Master", bundle: nil)
        let vc = storyboard.instantiateInitialViewController()
        vc?.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: false, completion: nil)
    }

    func registUserInfoToServer(){
        UserApi.shared.me() {(user, error) in
            if let error = error {
                print(error)
            }
            else {
                let userInfo = User(name: (user?.kakaoAccount?.profile!.nickname)!, age: (user?.kakaoAccount?.ageRange)!.rawValue, gender: (user?.kakaoAccount?.gender)!.rawValue, id: "\((user?.id)!)")
                // 1. UserDefault에 저장 2. firebaseDatabase에 저장
                self.userInfoManager.setUserInfo(userInfo: userInfo.toDictionary)
                self.firebaseManager.saveUserInfo(userInfo: userInfo.toDictionary)
            }
        }
    }
}
