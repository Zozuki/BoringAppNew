//
//  Service.swift
//  BoredApp
//
//  Created by user on 20.09.2021.
//

import UIKit


enum activities: String {
    case education = "&type=education",
         recreational = "&type=recreational",
         social = "&type=social",
         diy = "&type=diy",
         charity = "&type=charity",
         cooking = "&type=cooking",
         relaxation = "&type=relaxation",
         music = "&type=music",
         busywork = "&type=busywork"
}

protocol ServiceProtocol {
    func getActivity(types: [activities], participants count: Int, price: Double, completion: @escaping (_ activity: ActivityModel?, _ error: ErrorModel?) -> Void)
}

class Service: ServiceProtocol {
    
    func getActivity(types: [activities], participants count: Int, price: Double, completion: @escaping (_ activity: ActivityModel?, _ error: ErrorModel?) -> Void) {
        var rawTypes = String()
        
        for type in types {
            rawTypes.append(type.rawValue)
        }
        var paidPrice = ""
        
        if price <= 0 {
            paidPrice = "&price=0"
        } else {
            paidPrice = "&minprice=0.1&maxprice=0.9"
        }
        
        guard let url = URL(string: "https://www.boredapi.com/api/activity?participants=\(count)\(paidPrice)\(rawTypes)") else { return }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if response == nil {
                let connectionError = ErrorModel(error: "Нет подключения к сети")
                completion(nil, connectionError)
            }
            
            if let data = data, let error = try? JSONDecoder().decode(ErrorModel.self, from: data) {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
            
            if let data = data, let activity = try? JSONDecoder().decode(ActivityModel.self, from: data) {
                DispatchQueue.main.async {
                    completion(activity, nil)
                }
            }
        }
        task.resume()
    }
    
}
