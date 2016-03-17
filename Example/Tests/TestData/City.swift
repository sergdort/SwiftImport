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
   override class var map:[String : String] {
      return [ "cityId" : "id"]
   }
   
   override class var primaryAttribute: String {
      return "cityId"
   }
}