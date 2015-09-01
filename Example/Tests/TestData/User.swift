//
//  User.swift
//  
//
//  Created by Segii Shulga on 8/29/15.
//
//

import Foundation
import CoreData

class User: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

}

extension User {
   override class func mapped() -> [String : String] {
      return [ "userId" : "id", "lastName" : "last_name", "homeCity" : "home_city", "createdEvents" : "events"]
   }

   override class func relatedByAttribute() -> String {
      return "userId"
   }
   
   override class func relatedJsonKey() -> String {
      return "id"
   }
   
}