//
//  CharactorViewController.swift
//  GoTogeDog
//
//  Created by 이숭인 on 2021/03/23.
//

import UIKit
import PanModal

class CharacterViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var kindField: UITextField!
    @IBOutlet weak var ageField: UITextField!
    
    let characterViewModel = CharacterViewModel.shared
    let firebaseManager = FirebaseManager.shared
    let userInfoManager = UserInfoManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViews()
        characterViewModel.clearCharacters()
        collectionView.allowsMultipleSelection = true
    }
    
    func initViews(){
        nameField.delegate = self
        kindField.delegate = self
        ageField.delegate = self
    }
    
    func checkAlert(){
        let alert = UIAlertController(title: "정보 수정", message: "정말 수정하실건가요?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (ok) in
            self.compliteAlert()
        }
        let cancel = UIAlertAction(title: "cancel", style: .cancel) { (cancel) in }
        alert.addAction(cancel)
        alert.addAction(ok)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func compliteAlert(){
        let alert = UIAlertController(title: "정보 수정", message: "수정이 완료되었습니당.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (ok) in
            self.dismiss(animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "cancel", style: .cancel) { (cancel) in }
        alert.addAction(cancel)
        alert.addAction(ok)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func characterErrorAlert(){
        let alert = UIAlertController(title: "특징 설정", message: "특징을 설정해주세요.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (ok) in
            
        }
        let cancel = UIAlertAction(title: "cancel", style: .cancel) { (cancel) in }
        alert.addAction(cancel)
        alert.addAction(ok)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func dogInfoErrorAlert(){
        let alert = UIAlertController(title: "정보 입력", message: "모든 정보를 입력해주세요.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (ok) in
            
        }
        let cancel = UIAlertAction(title: "cancel", style: .cancel) { (cancel) in }
        alert.addAction(cancel)
        alert.addAction(ok)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func updateDogInfo(_ sender: Any) {
        let userInfo = userInfoManager.userInfo
        let age = ageField.text
        let name = nameField.text
        let kind = kindField.text
        
        if age == ""{ dogInfoErrorAlert() }
        else if name == ""{ dogInfoErrorAlert() }
        else if kind == "" { dogInfoErrorAlert() }
        
        if let selectedItems = collectionView.indexPathsForSelectedItems {
            if selectedItems.count == 0 { characterErrorAlert() }
            else{
                for item in selectedItems {
                    let character = characterViewModel.characterList[item.row]
                    characterViewModel.addCharacter(character: character)
                }
                
                firebaseManager.saveDogInfo(id: userInfo["id"]!, dogInfo: DogInfo(age: age!, characters: characterViewModel.characters, kind: kind!, name: name!))
                checkAlert()
            }//else
        }//selectedItems
    }
    
    @IBAction func tapGesture(_ sender: Any) {
        print("xoqxoq")
        nameField.resignFirstResponder()
        kindField.resignFirstResponder()
        ageField.resignFirstResponder()
    }
   
}

extension CharacterViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characterViewModel.characterList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "characterCell", for: indexPath) as? CharacterCell else {
            return UICollectionViewCell()
        }
    
        cell.configure(name: characterViewModel.characterList[indexPath.row])
        
        return cell
    }
    
}

extension CharacterViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}


extension CharacterViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSpacing : CGFloat = 16
        let margin : CGFloat = 16
        let width : CGFloat = (collectionView.bounds.width-itemSpacing - margin*2) / 2
        let height : CGFloat = 50

        return CGSize(width: width, height: height)
    }
}

extension CharacterViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
//MARK: - panModal Presentable
extension CharacterViewController : PanModalPresentable {
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

