//
//  ActivityModel.swift
//  BoredApp
//
//  Created by user on 20.09.2021.
//

import Foundation

// MARK: - ActivityModel
class ActivityModel: Codable {
    let accessibility: Double
    let price: Double
    let activity: String
    let participants: Int
    let type, link, key: String

    init(accessibility: Double, price: Double, activity: String, participants: Int, type: String, link: String, key: String) {
        self.accessibility = accessibility
        self.price = price
        self.activity = activity
        self.participants = participants
        self.type = type
        self.link = link
        self.key = key
    }
}
