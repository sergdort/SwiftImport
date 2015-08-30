//
//  CoreDataExtensions.swift
//  CoreDataImporter
//
//  Created by Segii Shulga on 8/28/15.
//  Copyright © 2015 Sergey Shulga. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObject {
   class var cdi_entityName:String {
      return "\(self)"
   }
   
   class func cdi_createEntityInContext(context:NSManagedObjectContext) -> NSManagedObject {
      return NSEntityDescription.insertNewObjectForEntityForName(self.cdi_entityName, inManagedObjectContext: context)
   }
   
   class func cdi_findFirst(value:AnyObject, key:String, context:NSManagedObjectContext) -> NSManagedObject? {
      let request = NSFetchRequest()
      let entity = NSEntityDescription.entityForName(self.cdi_entityName, inManagedObjectContext: context)
      request.entity = entity
      if let str = value as? String {
         request.predicate = NSPredicate(format: "%K == %@", key, str)
      } else {
         request.predicate = NSPredicate(format:"\(key) == \(value)")
      }
      
      do {
         let data = try context.executeFetchRequest(request)
         return data.first as? NSManagedObject
      } catch {
         print("NSManagedObject dte_findFirst ERROR:\(error)")
         return .None
      }
   }
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

extension NSManagedObject {
   
   func update(json:JSONDictionary) {
      for (jsonKey, mappedKey) in self.classForCoder.mappedKeys() {
         self.updateValue <^> json[jsonKey] <*> mappedKey
      }
   }
   
   func updateValue(value:AnyObject)(key:String) {
      if let json = value as? JSONDictionary {
         self.updateRelationship <^> json <*> key
      } else if let array = value as? [JSONDictionary] {
         self.updateRelationships <^> array <*> key
      } else {
         self.setValue(value, forKey: key)
      }
   }
   
   func updateRelationship(json:JSONDictionary)(key:String) {
      guard let relation = self.entity.relationshipsByName[key],
         let entity = relation.destinationEntity,
         let name = entity.managedObjectClassName,
         let clas = NSClassFromString(name) as? NSManagedObject.Type,
         let value = json[clas.relatedJsonKey()],
         let context = self.managedObjectContext else {
            return;
      }
      if relation.toMany == true {
         return
      }
      if let relationObj = clas.cdi_findFirst(value, key: clas.relatedByAttribute(), context: context) {
         relationObj.update(json)
      } else {
         let relationObj = clas.cdi_createEntityInContext(context)
         relationObj.update(json)
         self.setValue(relationObj, forKey: key)
      }
   }
   
   func updateRelationships(array:[JSONDictionary])(key:String) {
      guard let relation = self.entity.relationshipsByName[key],
         let entity = relation.destinationEntity,
         let name = entity.managedObjectClassName,
         let clas = NSClassFromString(name) as? NSManagedObject.Type else {
            return;
      }
      if relation.toMany == false {
         return
      }
      for json in array {
         guard let value = json[clas.relatedJsonKey()],
            let context = self.managedObjectContext else {
               return
         }
         if let relationObj = clas.cdi_findFirst(value, key: clas.relatedByAttribute(), context: context) {
            let selector = Selector("add\(relation.name.capitalizedString)Object:")
            relationObj.update(json)
            if self.respondsToSelector(selector) {
               self.performSelector(selector, withObject: relationObj)
            }

         } else {
            let relationObj = clas.cdi_createEntityInContext(context)
            let selector = Selector("add\(relation.name.capitalizedString)Object:")
            relationObj.update(json)
            if self.respondsToSelector(selector) {
               self.performSelector(selector, withObject: relationObj)
            }
         }
      }
   }

   
}

extension NSManagedObject {
   class func importObject(json:JSONDictionary)(context:NSManagedObjectContext) throws -> NSManagedObject {
      guard let value = json[self.relatedJsonKey()] else  {
         throw ImportError.InvalidJSON
      }
      if let obj = self.cdi_findFirst(value, key: self.relatedByAttribute(), context: context) {
         obj.update(json)
         return obj
      } else {
         let obj = self.cdi_createEntityInContext(context)
         obj.update(json)
         return obj
      }
   }
}

extension String {
   public func swi_capitalizedFirstCharacterString() -> String? {
      if self.characters.count > 0 {
         let firstChar = self.substringToIndex(self.startIndex.successor()).capitalizedString
         return firstChar + self.substringFromIndex(self.startIndex.successor())
      } else {
         return nil
      }
   }
//   - (NSString *) MR_capitalizedFirstCharacterString;
//   {
//   if ([self length] > 0)
//   {
//   NSString *firstChar = [[self substringToIndex:1] capitalizedString];
//   return [firstChar stringByAppendingString:[self substringFromIndex:1]];
//   }
//   return self;
//   }

}

