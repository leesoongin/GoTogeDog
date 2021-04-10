//
//  KakaoAPIManager.swift
//  GoTogeDog
//
//  Created by 이숭인 on 2021/03/19.
//

import UIKit
import Alamofire

private let RegioncodeRequestUrl : String = "https://dapi.kakao.com/v2/local/geo/coord2regioncode.json"
private let HEADER_KEY : String = "Authorization"
private let HEADER_VALUE : String = "KakaoAK 2691c214afbbc0d1e060cc6509bdc235"

class KakaoAPIManager {
    
    func requestRegioncode(param : RegioncodeParam,completion : @escaping (Regioncode)->(Void)){
        AF.request(RegioncodeRequestUrl,method: .get, parameters: param.toDictionary,headers: [HEADER_KEY : HEADER_VALUE]).validate(statusCode: 200..<300).responseJSON { response in
            switch response.result {
            case .success:
                do{
                    let jsonData = try JSONSerialization.data(withJSONObject: response.value!, options: .prettyPrinted)
                    let json = try JSONDecoder().decode(Regioncode.self, from: jsonData)
                    completion(json)
                }catch let error {
                    print("parsing error -> \(error.localizedDescription)")
                }
            case .failure:
                print("fail , statusCode --> \(response.result)")
            }
        }
    }
}
