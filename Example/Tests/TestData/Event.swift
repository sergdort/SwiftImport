//
//  Event.swift
//  SHUJSONKit
//
//  Created by Segii Shulga on 8/29/15.
//  Copyright © 2015 Sergey Shulga. All rights reserved.
//

import Foundation
import CoreData

class Event: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

}

extension Event {
   override class func mappedKeys() -> [String : String] {
      return [ "id" : "eventId", "name" : "name", "location_name" : "locationName", "address" : "address"]
   }
   
   override class func relatedByAttribute() -> String {
      return "eventId"
   }
   
   override class func relatedJsonKey() -> String {
      return "id"
   }
   
}