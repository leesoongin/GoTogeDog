//
//  TabbarViewController.swift
//  GoTogeDog
//
//  Created by 이숭인 on 2021/03/15.
//

import UIKit
import KakaoSDKUser

class MasterViewController: UITabBarController {
    let userInfoManager = UserInfoManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("userInfo ----> \(userInfoManager.userInfo)")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
