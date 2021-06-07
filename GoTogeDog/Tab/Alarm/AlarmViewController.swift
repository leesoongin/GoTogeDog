//
//  AlarmViewController.swift
//  GoTogeDog
//
//  Created by 이숭인 on 2021/05/04.
//

import UIKit

class AlarmViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImage: UIImageView!
    
    let alarmViewModel = AlarmViewModel.shared
    let firebaseManager = FirebaseManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    //response -> profile
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        alarmViewModel.clearRequestMate()
        
        firebaseManager.loadWalkingMateId { idResponse in

            for item in idResponse{
                self.firebaseManager.loadAroundUserInfo(id: item.id) { response in
                    self.alarmViewModel.addRequestMate(profile: response,id: item.id)
                    
                    if item.id == idResponse.last?.id{
                        self.alarmViewModel.sortRequestMate()
                        self.tableView.reloadData()
                    }//if
                }
            }//for
        } //completion
    }
}

extension AlarmViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "AlarmDetail", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! AlarmDetailViewController
        presentPanModal(vc)
        
        NotificationCenter.default.post(name: NSNotification.Name.getUserCard, object: self.alarmViewModel.requestedMate[indexPath.row])
    }
}

extension AlarmViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarmViewModel.requestedMate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "alarmCell", for: indexPath) as? AlarmCell else {
            return UITableViewCell()
        }
        let name = alarmViewModel.requestedMate[indexPath.row].profile.Owner.nickName
        let imageUrl = alarmViewModel.requestedMate[indexPath.row].profile.OwnerImages.imageUrls.first
        cell.configure(nicName: name, imageUrl: imageUrl!)
        
        return cell
    }
    
    
}
