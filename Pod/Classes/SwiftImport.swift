//
//  CoreDataImporter.swift
//  CoreDataImporter
//
//  Created by Segii Shulga on 8/28/15.
//  Copyright © 2015 Sergey Shulga. All rights reserved.
//

import Foundation
import CoreData

enum ImportError:ErrorType {
   case InvalidJSON
}

public protocol JSONToEntityMapable {
   static func mapped() -> [String:String] //[entityKey : jsonKey]
   static var relatedByAttribute:String {get}
   static var relatedJsonKey:String {get}
}

public class SwiftImport<Element:NSManagedObject> {
   
   public class func importObject(context:NSManagedObjectContext) -> (dict:JSONDictionary) throws -> Element {
      return { dict in
         do {
            return try Element.swi_importObject(dict)(context) as! Element
         } catch {
            throw error
         }
      }
   }
   
   public class func importObjects(context:NSManagedObjectContext) -> (array:[JSONDictionary]) throws -> [Element] {
      return { array in
         return try array.map(importObject(context))
      }
   }
}

