//
//  LodingViewController.swift
//  GoTogeDog
//
//  Created by 이숭인 on 2021/03/15.
//

import UIKit
import Lottie

class LodingViewController: UIViewController {
    
    let animationView = AnimationView(name:"GotogeDog_Loding_Animation")
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //메인 뷰에 삽입
        view.addSubview(animationView)
        view.backgroundColor =  #colorLiteral(red: 0.9387887716, green: 0.9399248958, blue: 0.7486882806, alpha: 1)
        animationView.frame = CGRect(x: 0, y: 0, width: 250, height: 250) // 애니메이션뷰의 크기 설정
        animationView.center = self.view.center // 애니메이션뷰의 위치설정
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 2.0
        animationView.loopMode = .loop
        //애니메이션 재생(애니메이션 재생모드 미 설정시 1회)
        animationView.play()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        let time = DispatchTime.now() + .seconds(2)
        DispatchQueue.main.asyncAfter(deadline: time) {
            self.animationView.pause()
            self.moveToLogin()
        }
    }
    
    func moveToLogin() {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let vc = storyboard.instantiateInitialViewController()
        vc?.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: false, completion: nil)
    }
}
