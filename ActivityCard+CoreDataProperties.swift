//
//  ActivityCard+CoreDataProperties.swift
//  
//
//  Created by user on 28.09.2021.
//
//

import Foundation
import CoreData


extension ActivityCard {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ActivityCard> {
        return NSFetchRequest<ActivityCard>(entityName: "ActivityCard")
    }

    @NSManaged public var participants: String?
    @NSManaged public var price: Bool
    @NSManaged public var text: String?
    @NSManaged public var type: String?

}
