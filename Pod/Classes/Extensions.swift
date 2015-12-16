//
//  CoreDataExtensions.swift
//  CoreDataImporter
//
//  Created by Segii Shulga on 8/28/15.
//  Copyright © 2015 Sergey Shulga. All rights reserved.
//

import Foundation
import CoreData

//MARK:Public
extension NSManagedObject:JSONToEntityMapable {
   public class var map:[String:String] { //[entityKey : jsonKey]
      return [:]
   }
   public class var relatedByAttribute:String {
      return ""
   }
   public class var relatedJsonKey:String {
      return ""
   }
}

extension NSManagedObject:Importable {
   public static func importIn(context: NSManagedObjectContext) -> (json: JSONDictionary) throws -> NSManagedObject {
      return { json in
         guard let value = json[self.relatedJsonKey] else  {
            throw ImportError.InvalidJSON
         }
         
         return swi_ifFindFirst(relatedByAttribute,
            value: value,
            context: context,
            elseThen: swi_createEntityInContext)
            .swi_updateWith(json)
      }
   }
}

//MARK:Private

extension NSManagedObject {
   class var swi_entityName:String {
      return "\(self)"
   }
   
   class func swi_createEntityInContext(context:NSManagedObjectContext) -> NSManagedObject {
      return NSEntityDescription.insertNewObjectForEntityForName(swi_entityName, inManagedObjectContext: context)
   }
   
   class func swi_findFirst(value:AnyObject,
      key:String,
      context:NSManagedObjectContext) -> NSManagedObject? {
         
         let request = NSFetchRequest()
         request.entity = NSEntityDescription.entityForName(swi_entityName, inManagedObjectContext: context)
         
         if let str = value as? String {
            request.predicate = NSPredicate(format: "%K == %@", key, str)
         } else {
            request.predicate = NSPredicate(format:"\(key) == \(value)")
         }
         
         do {
            let data = try context.executeFetchRequest(request)
            return data.first as? NSManagedObject
         } catch {
            print("NSManagedObject swi_findFirst ERROR:\(error)")
            return .None
         }
   }
   
   class func swi_ifFindFirst(key:String,
      value:AnyObject ,
      context:NSManagedObjectContext,
      elseThen: NSManagedObjectContext -> NSManagedObject ) -> NSManagedObject {
         
         if let first = swi_findFirst(value, key: key, context: context) {
            return first
         } else {
            return elseThen(context)
         }
   }
   
}

extension NSManagedObject {
   
   private func swi_setValue(value:AnyObject) -> (key:String) -> NSManagedObject {
      return { key in
         self.setValue(value, forKey: key)
         return self
      }
   }
   
   private func swi_updatePropertiesWith(json:JSONDictionary) {
      entity.attributesByName.forEach { (tuple) -> () in
         swi_setValue
            <^> json[classForCoder.map[tuple.0] ?? tuple.0]
            <*> tuple.0
      }
   }
   
   private func swi_updateRelationsWith(json:JSONDictionary) {
      entity.relationshipsByName.forEach { (tuple) -> () in
         swi_updateRelationship
            <^> JSONObject -<< json[classForCoder.map[tuple.0] ?? tuple.0]
            <*> tuple.0
         swi_updateRelationships
            <^> JSONObjects -<< json[classForCoder.map[tuple.0] ?? tuple.0]
            <*> tuple.0
      }
   }
   
   func swi_updateWith(json:JSONDictionary) -> NSManagedObject {
      swi_updatePropertiesWith(json)
      swi_updateRelationsWith(json)
      return self
   }
   
   func swi_updateRelationship(json:JSONDictionary) -> (key:String) -> Void {
      return { key in
         guard let relation = self.entity.relationshipsByName[key],
            entity = relation.destinationEntity,
            name = entity.managedObjectClassName,
            clas = NSClassFromString(name) as? NSManagedObject.Type,
            value = json[clas.relatedJsonKey],
            context = self.managedObjectContext
            where relation.toMany == false else {
               return;
         }
         
         let obj = clas.swi_ifFindFirst(clas.relatedByAttribute,
            value: value,
            context: context,
            elseThen: clas.swi_createEntityInContext)
            .swi_updateWith(json)
         self.setValue(obj, forKey: key)
      }
   }
   
   func swi_updateRelationships(array:[JSONDictionary])(key:String) {
      guard let relation = self.entity.relationshipsByName[key],
         entity = relation.destinationEntity,
         name = entity.managedObjectClassName,
         clas = NSClassFromString(name) as? NSManagedObject.Type
         where relation.toMany else {
            return;
      }
      
      for json in array {
         guard let value = json[clas.relatedJsonKey],
            let context = self.managedObjectContext else {
               return
         }
         
         let obj = clas.swi_ifFindFirst(clas.relatedByAttribute,
            value: value,
            context: context,
            elseThen: clas.swi_createEntityInContext)
            .swi_updateWith(json)
         let selector = Selector("add\(relation.name.swi_capitalizedFirstCharacterString()!)Object:")
         if self.respondsToSelector(selector) {
            self.performSelector(selector, withObject: obj)
         }
      }
   }
   
}

extension String {
   public func swi_capitalizedFirstCharacterString() -> String? {
      if characters.count > 0 {
         let firstChar = self.substringToIndex(self.startIndex.successor()).capitalizedString
         return firstChar + self.substringFromIndex(self.startIndex.successor())
      } else {
         return nil
      }
   }
}



