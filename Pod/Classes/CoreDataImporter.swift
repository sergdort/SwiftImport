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

extension NSManagedObject:JSONToEntityMapable {
   public class func mappedKeys() -> [String : String] {
      return [:]
   }
   public class func relatedByAttribute() -> String {
      return ""
   }
   public class func relatedJsonKey() -> String {
      return ""
   }
}

public class CoreDataImporter<Element:NSManagedObject> {
   
   public class func importObject(dict:JSONDictionary)(context:NSManagedObjectContext) throws  -> Element {
      guard let value = dict[Element.relatedJsonKey()] else {
         throw ImportError.InvalidJSON
      }
      
      if let element = self.findMeFirst <<< Element.relatedByAttribute()
         <^> value
         <*> context, _ = self.update <^> element <*> dict {
            return element!
      } else {
         return (self.update <^> self.createMeInContext <<< context <*> dict)!
      }
      
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
   
   class func update(element:Element)(dict:[String:AnyObject]) -> Element {
      for (jsonKey, mappedKey) in Element.mappedKeys() {
         self.updateObj <^> element <*> dict[jsonKey] <*> mappedKey
      }
      return element
   }
   
   class func updateObj(object:Element)(value: AnyObject)(key: String) {
      (object as NSManagedObject).setValue(value, forKey: key)
   }
   
   class func createMeInContext(context:NSManagedObjectContext) -> Element {
      return Element.cdi_createEntityInContext(context) as! Element
   }
   
   class func findMeFirst(key:String)(value:AnyObject)(context:NSManagedObjectContext) -> Element? {
      return Element.cdi_findFirst(value, key: key, context: context) as? Element
   }
   
}
