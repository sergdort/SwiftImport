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
   override class var map:[String : String] {
      return [ "userId" : "id", "lastName" : "last_name", "homeCity" : "home_city", "createdEvents" : "events"]
   }

   override class var primaryAttribute: String {
      return "userId"
   }
}