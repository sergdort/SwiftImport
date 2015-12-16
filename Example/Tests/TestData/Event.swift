//
//  Event.swift
//  SHUJSONKit
//
//  Created by Segii Shulga on 8/29/15.
//  Copyright © 2015 Sergey Shulga. All rights reserved.
//

import Foundation
import CoreData
import SwiftImport

class Event: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

}

extension Event {
   override class var map:[String : String] {
      return [ "eventId" : "id", "locationName" : "location_name"]
   }
   
   override class var relatedByAttribute: String {
      return "eventId"
   }
   
   override class var relatedJsonKey: String {
      return "id"
   }
   
}