//
//  DogProfileImageViewController.swift
//  GoTogeDog
//
//  Created by 이숭인 on 2021/03/23.
//

import UIKit
import PanModal
import YPImagePicker


class DogProfileImageViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let dogProfileViewModel = DogProfileViewModel()
    
    var config = YPImagePickerConfiguration()
    var photoData : Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func addProfileImage(_ sender: Any) {
        config.library.maxNumberOfItems = 3
        let picker = YPImagePicker(configuration: config)
        
        picker.didFinishPicking { [unowned picker] items, cancelled in
            if cancelled {
                picker.dismiss(animated: true, completion: nil)
                return
            }
            //이미지 받아와서 viewModel에 넣기
            for item in items {
                switch item {
                case .photo(let photo):
                    self.dogProfileViewModel.addImage(image:photo.image)
                default :
                    print("이거나오면앙댕 영상일경우걸릴걸? ㅋㅋㅅㅋ")
                }
            }
            
            picker.dismiss(animated: true, completion: nil)
            self.collectionView.reloadData()
        }
        present(picker, animated: true, completion: nil)
        
    }
    @IBAction func setDogImages(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("dogImages"), object: nil, userInfo: dogProfileViewModel.imagesToDictionary)
        dismiss(animated: true, completion: nil)
    }
}

extension DogProfileImageViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dogProfileViewModel.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dogImageCell", for: indexPath) as? DogImageCell else {
            return UICollectionViewCell()
        }

        cell.imageView.image = dogProfileViewModel.images[indexPath.row]
        
        return cell
    }
}

extension DogProfileImageViewController : UICollectionViewDelegate {
    
}

extension DogProfileImageViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSpacing : CGFloat = 16
        let margin : CGFloat = 16
        let width : CGFloat = (collectionView.bounds.width-itemSpacing - margin*2)
        let height : CGFloat = width

        return CGSize(width: width, height: height)
    }
}

//MARK: - panModal Presentable
extension DogProfileImageViewController : PanModalPresentable {
    var panScrollable: UIScrollView? {
            return nil
        }
    
    // 접힌 상태
    var shortFormHeight: PanModalHeight {
        return .contentHeight(300)
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
