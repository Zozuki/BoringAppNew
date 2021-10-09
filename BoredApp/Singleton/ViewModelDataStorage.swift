//
//  ViewModelDataStorage.swift
//  BoredApp
//
//  Created by user on 21.09.2021.
//

import UIKit


class ViewModelDataStorage: NSObject {
    
    static let shared = ViewModelDataStorage()
    
    private override init() {
        super.init()
    }
    
    var activityModels = [ActivityCardsDataModel]()
    

    
    func addNewActivity(activity: ActivityModel) {
        let colorAndType = configureTextAndColorOfType(activity: activity)
        let activityCardModel = ActivityCardsDataModel(bgTypeColor: colorAndType.color, activityText: activity.activity, activityType: colorAndType.type, activityParticipants: activity.participants, activityPrice: activity.price)
        activityModels.append(activityCardModel)
    }
    
    func configureTextAndColorOfType(activity: ActivityModel) -> (color: UIColor, type: String) {
        if "\(activities.cooking)" ==  activity.type {
            return (UIColor.systemPurple, "  Cooking      ")
        } else if "\(activities.education)" ==  activity.type {
            return (UIColor.systemIndigo, "  Education      ")
        } else if "\(activities.recreational)" ==  activity.type {
            return (UIColor.systemOrange, "  Recreational      ")
        } else if "\(activities.diy)" ==  activity.type {
            return (UIColor.systemGreen, "  DIY      ")
        } else if "\(activities.charity)" ==  activity.type {
            return (UIColor.systemRed, "  Charity      ")
        } else if "\(activities.social)" ==  activity.type {
            return (UIColor.systemYellow, "Social      ")
        } else if "\(activities.music)" ==  activity.type{
            return (UIColor.systemTeal, "  Music      ")
        } else if "\(activities.relaxation)" ==  activity.type {
            return (UIColor.systemPink, "  Relaxation      ")
        } else {
            return (UIColor.systemBlue, "  Busywork      ")
        }
    }
    
}
