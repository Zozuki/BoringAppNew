//
//  ActivityCriteria.swift
//  BoredApp
//
//  Created by user on 21.09.2021.
//

import UIKit

class ActivitySearchCriteria: NSObject {
    
    static let shared = ActivitySearchCriteria()
    
    private override init() {
        self.types = [.social]
        self.price = 0.1
        self.participants = 2
        super.init()
    }
    
    private let service = Service()
    var types: [activities]
    var price: Double
    var participants: Int
    
    func search(completion: @escaping (ErrorModel?) -> Void) {
        service.getActivity(types: types, participants: participants, price: price) {  activity, error  in
            DispatchQueue.main.async {
                if activity != nil {
                    guard let activity = activity else { return }
                    ViewModelDataStorage.shared.addNewActivity(activity: activity)
                    completion(error)
                } else {
                    completion(error)
                }
            }
        }
    }
    
    func searchWithTypeCriteria(type: activities,completion: @escaping (ErrorModel?) -> Void) {
        service.getActivity(types: [type], participants: participants, price: price) {  activity, error  in
            DispatchQueue.main.async {
                if activity == nil {
                    completion(error)
                } else {
                    completion(error)
                }
            }
        }
    }
}
