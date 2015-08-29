//
//  Event+CoreDataProperties.swift
//  SHUJSONKit
//
//  Created by Segii Shulga on 8/29/15.
//  Copyright © 2015 Sergey Shulga. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Event {

    @NSManaged var eventId: NSNumber?
    @NSManaged var name: String?
    @NSManaged var locationName: String?
    @NSManaged var address: String?

}
