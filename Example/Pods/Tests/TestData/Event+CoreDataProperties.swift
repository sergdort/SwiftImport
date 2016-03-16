//
//  Event+CoreDataProperties.swift
//  SwiftImport
//
//  Created by Segii Shulga on 9/1/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Event {

    @NSManaged var address: String?
    @NSManaged var eventId: NSNumber?
    @NSManaged var locationName: String?
    @NSManaged var name: String?
    @NSManaged var creator: User?
    @NSManaged var participants: NSSet?

}
