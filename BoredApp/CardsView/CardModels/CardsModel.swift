//
//  CardsModel.swift
//  BoredApp
//
//  Created by user on 20.09.2021.
//

import UIKit

struct ActivityCardsDataModel {
    
    var bgTypeColor: UIColor
    var activityText: String
    var activityType: String
    var activityParticipants: Int
    var activityPrice: Double
    
    init(bgTypeColor: UIColor, activityText: String, activityType: String, activityParticipants: Int,
    activityPrice: Double) {
        self.bgTypeColor = bgTypeColor
        self.activityText = activityText
        self.activityType = activityType
        self.activityParticipants = activityParticipants
        self.activityPrice = activityPrice
    }
}
