//
//  IntroduceViewController.swift
//  GoTogeDog
//
//  Created by 이숭인 on 2021/03/31.
//

import UIKit
import PanModal

class IntroduceViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var headView: UIView!
    
    @IBOutlet weak var nickNameField: UITextField!
    @IBOutlet weak var genderField: UITextField!
    @IBOutlet weak var ageField: UITextField!
    
    let userInfoManager = UserInfoManager.shared
    let firebaseManager = FirebaseManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initViews()
    }
    
    func initViews(){

        nickNameField.delegate = self
        genderField.delegate = self
        ageField.delegate = self
    }
    
    func completeAlert(){
        let alert = UIAlertController(title: "정보 수정", message: "수정이 완료되었습니당.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (ok) in
            self.dismiss(animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "cancel", style: .cancel) { (cancel) in }
        alert.addAction(cancel)
        alert.addAction(ok)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func ownerInfoErrorAlert(){
        let alert = UIAlertController(title: "정보 입력", message: "모든 정보를 입력해주세요.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (ok) in }
        let cancel = UIAlertAction(title: "cancel", style: .cancel) { (cancel) in }
        alert.addAction(cancel)
        alert.addAction(ok)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func updateOwnerInfo(_ sender: Any) {
        let userInfo = userInfoManager.userInfo
        let nickName = nickNameField.text!
        let gender = genderField.text!
        let age = ageField.text!
        let introduce = textView.text!
        
        if nickName == "" { ownerInfoErrorAlert() }
        else if gender == "" { ownerInfoErrorAlert() }
        else if age == "" { ownerInfoErrorAlert() }
        else if introduce == "" { ownerInfoErrorAlert() }
        
        firebaseManager.saveOwnerInfo(id: userInfo["id"]!, ownerInfo: OwnerInfo(nickName: nickName, gender: gender, age: age, introduce: introduce))
        
        completeAlert()
    }
    
    @IBAction func tapGesture(_ sender: Any) {
        textView.resignFirstResponder()
        nickNameField.resignFirstResponder()
        ageField.resignFirstResponder()
        genderField.resignFirstResponder()
    }
}

extension IntroduceViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

//MARK: - panModal Presentable
extension IntroduceViewController : PanModalPresentable {
    var panScrollable: UIScrollView? {
            return nil
        }
   
//    펼쳐진 상태
    var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(0)
    }
    //true -> 최상단까지 펼쳐지지 않음 , false -> 최상단까지 펼쳐짐
    var anchorModalToLongForm: Bool {
        return false
    }
}

