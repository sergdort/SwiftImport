//
//  City.swift
//  SwiftImport
//
//  Created by Segii Shulga on 8/30/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import Foundation
import CoreData

class City: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

}

extension City {
   override class func mapped() -> [String : String] {
      return [ "cityId" : "id"]
   }
   
   override class func relatedByAttribute() -> String {
      return "cityId"
   }
   
   override class func relatedJsonKey() -> String {
      return "id"
   }
}