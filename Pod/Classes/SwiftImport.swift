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
   static func mappedKeys() -> [String:String]
   static func relatedByAttribute() -> String
   static func relatedJsonKey() -> String
}

public class SwiftImport<Element:NSManagedObject> {
   
   public class func importObject(dict:JSONDictionary)(context:NSManagedObjectContext) throws  -> Element {
      guard let _ = dict[Element.relatedJsonKey()] else {
         throw ImportError.InvalidJSON
      }
      return (Element.swi_importObject <^> dict <*> context) as! Element
   }
   
   public class func importObjects(array:[JSONDictionary])(context:NSManagedObjectContext) throws -> [Element] {
      do {
         return try array.map{
            do {
               return try importObject($0)(context: context)
            } catch {
               throw ImportError.InvalidJSON
            }
         }
      } catch {
         throw ImportError.InvalidJSON
      }
   }
}
