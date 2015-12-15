//
//  DummyEntity+CoreDataProperties.swift
//  SwiftImport
//
//  Created by Segii Shulga on 12/15/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension DummyEntity {

    @NSManaged var entityId: NSNumber?
    @NSManaged var name: String?
    @NSManaged var secondName: String?

}
