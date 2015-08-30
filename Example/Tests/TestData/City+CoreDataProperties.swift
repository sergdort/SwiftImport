//
//  City+CoreDataProperties.swift
//  SwiftImport
//
//  Created by Segii Shulga on 8/30/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension City {

    @NSManaged var cityId: NSNumber?
    @NSManaged var name: String?
    @NSManaged var people: NSSet?

}
