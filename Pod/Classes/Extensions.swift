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
}

extension NSManagedObject:Importable {
   public static func importIn(context: NSManagedObjectContext) -> (json: JSONDictionary) throws -> NSManagedObject {
      return { json in
         guard let value = json[map[relatedByAttribute] ?? relatedByAttribute] else  {
            throw ImportError.InvalidJSON
         }
         
         return try swi_ifFindFirst(relatedByAttribute,
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
         request.predicate = NSPredicate(format: "%K == \(value)", key)
         
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
   
   func swi_updateWith(json:JSONDictionary) throws -> NSManagedObject {
      do {
         try swi_updatePropertiesWith(json)
         try swi_updateRelationsWith(json)
      } catch {
         throw error
      }
      return self
   }
   
   private func swi_updatePropertiesWith(json:JSONDictionary) throws -> Void {
      try entity.attributesByName.forEach { (tuple) -> () in
         do {
            try swi_updateAttribute(tuple.1)
               <^> json[classForCoder.map[tuple.0] ?? tuple.0]
               <*> tuple.0
         } catch {
            throw error
         }
      }
   }
   
   private func swi_updateRelationsWith(json:JSONDictionary) throws -> Void {
      try entity.relationshipsByName.forEach { (tuple) -> () in
         do {
            try swi_updateRelationship
               <^> JSONObject -<< json[classForCoder.map[tuple.0] ?? tuple.0]
               <*> tuple.0
            try swi_updateRelationships
               <^> JSONObjects -<< json[classForCoder.map[tuple.0] ?? tuple.0]
               <*> tuple.0
         } catch {
            throw error
         }
      }
   }
   
   private func swi_updateRelationship(json:JSONDictionary) -> (key:String) throws -> Void {
      return { key in
         guard let relation = self.entity.relationshipsByName[key],
            entity = relation.destinationEntity,
            name = entity.managedObjectClassName,
            clas = NSClassFromString(name) as? NSManagedObject.Type,
            value = json[clas.map[clas.relatedByAttribute] ?? clas.relatedByAttribute],
            context = self.managedObjectContext
            where relation.toMany == false else {
               return;
         }
         do {
            let obj = try clas.swi_ifFindFirst(clas.relatedByAttribute,
               value: value,
               context: context,
               elseThen: clas.swi_createEntityInContext)
               .swi_updateWith(json)
            self.setValue(obj, forKey: key) // setting value for relationship
         } catch {
            throw error
         }
      }
   }
   
   private func swi_updateRelationships(array:[JSONDictionary]) -> (key:String) throws -> Void {
      return { key in
         guard let relation = self.entity.relationshipsByName[key],
            entity = relation.destinationEntity,
            name = entity.managedObjectClassName,
            clas = NSClassFromString(name) as? NSManagedObject.Type
            where relation.toMany else {
               return;
         }
         
         for json in array {
            guard let value = json[clas.map[clas.relatedByAttribute] ?? clas.relatedByAttribute],
                  context = self.managedObjectContext else {
                  return
            }
            do {
               let obj = try clas.swi_ifFindFirst(clas.relatedByAttribute,
                  value: value,
                  context: context,
                  elseThen: clas.swi_createEntityInContext)
                  .swi_updateWith(json)
               let selector = Selector("add\(relation.name.swi_capitalizedFirstCharacterString()!)Object:")
               
               assert(self.respondsToSelector(selector))//this should not happened
               
               if self.respondsToSelector(selector) {
                  self.performSelector(selector, withObject: obj)
               }
            } catch {
               throw error
            }

         }
      }
   }
   
   private func swi_updateAttribute(att:NSAttributeDescription)
      -> (value:AnyObject)
      -> (key:String) throws -> NSManagedObject {
         return { value in
            return { key in
               if att.attributeValueClassName == NSStringFromClass(value.classForCoder!) {
                  self.setValue(value, forKey: key)
               } else {
                  throw ImportError.WrongValueForKey(value: value, key: key)
               }
               return self
            }
         }
         
   }
   
}

extension String {
   func swi_capitalizedFirstCharacterString() -> String? {
      if characters.count > 0 {
         let firstChar = self.substringToIndex(self.startIndex.successor()).capitalizedString
         return firstChar + self.substringFromIndex(self.startIndex.successor())
      } else {
         return nil
      }
   }
}



