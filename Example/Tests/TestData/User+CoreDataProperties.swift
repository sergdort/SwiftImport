//
//  User+CoreDataProperties.swift
//  
//
//  Created by Segii Shulga on 8/29/15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension User {

    @NSManaged var userId: NSNumber?
    @NSManaged var name: String?
    @NSManaged var lastName: String?

}
