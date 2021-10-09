//
//  DataStoreManager.swift
//  BoredApp
//
//  Created by user on 28.09.2021.
//

import UIKit
import CoreData

class DataStoreManager {
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
       
        let container = NSPersistentContainer(name: "BoredApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var viewContext: NSManagedObjectContext = persistentContainer.viewContext
    
    // MARK: - Core Data Saving support
    
    func obtainActivity(type: String, text: String, participants: String, price: Bool) {
        let activity = ActivityCard(context: viewContext)
        activity.type = type
        activity.text = text
        activity.participants = participants
        activity.price = price
        do {
            try viewContext.save()
        } catch let error {
            print("Error: \(error)")
        }
    }
    
    func getActivityFromCoreData() -> [ActivityCardsDataModel] {
        let fetchRequest: NSFetchRequest<ActivityCard> = ActivityCard.fetchRequest()
        let objects = try! viewContext.fetch(fetchRequest)
        var activityFromCD = [ActivityCardsDataModel]()
        
        for activity in objects {
            let color = configureColorOfType(activityType: activity.type!)
            let count = Int(activity.participants!)!
            var price = 0.0
            if activity.price == true {
                price = 0.1
            }
            let activityModel = ActivityCardsDataModel(bgTypeColor: color, activityText: activity.text!, activityType: activity.type!, activityParticipants: count, activityPrice: price)
            activityFromCD.append(activityModel)
        }
        
        return activityFromCD
    }
    
    private func configureColorOfType(activityType: String ) -> UIColor {
        if activityType  ==  "  Cooking      " {
            return UIColor.systemPurple
        } else if activityType ==  "  Education      " {
            return UIColor.systemIndigo
        } else if activityType ==  "  Recreational      " {
            return UIColor.systemOrange
        } else if activityType ==  "  DIY      " {
            return UIColor.systemGreen
        } else if activityType ==  "  Charity      " {
            return UIColor.systemRed
        } else if activityType ==  "Social      " {
            return UIColor.systemYellow
        } else if activityType ==  "  Music      " {
            return UIColor.systemTeal
        } else if activityType ==  "  Relaxation      "{
            return UIColor.systemPink
        } else {
            return UIColor.systemBlue
        }
    }
}
