//
//  DummyEntity.swift
//  SwiftImport
//
//  Created by Segii Shulga on 12/15/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import Foundation
import CoreData
import SwiftImport


class DummyEntity: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

}

extension DummyEntity {
   override class var relatedByAttribute: String {
      return "entityId"
   }
   
   override class var relatedJsonKey: String {
      return "entityId"
   }
}