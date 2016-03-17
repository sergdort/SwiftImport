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
extension NSManagedObject: JSONToEntityMapable {
   /// map dictionary for entityKey to jsonKey
   public class var map: [String:String] {
      return [:]
   }
   /// Primary attribute name of the Entity
   public class var primaryAttribute: String {
      return ""
   }
}

private let lock = NSLock()

extension NSManagedObject {
   /// key for lazy associated property
   private static let dateFormatterKey = "com.swiftimport.NSManagedObject.dateFormatterKey"
   /// default date format
   public class var dateFormat: String {
      return "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"
   }
   /// default date formatter singleton
   class var dateFormatter: NSDateFormatter {
      lock.lock()
      defer {lock.unlock()}
      let formatter = lazyAssociatedProperty(self, key: dateFormatterKey, factory: {
         return NSDateFormatter()
      })
      formatter.dateFormat = dateFormat
      return formatter
   }
}

extension NSManagedObject {
   static func importIn(context: NSManagedObjectContext)
      -> (json: JSONDictionary)
      throws -> NSManagedObject {
      return { json in
         guard let value = json[map[primaryAttribute] ?? primaryAttribute] else {
            throw ImportError.MissingPrimaryAttribute(entityName: swi_entityName)
         }
         return try swi_ifFindFirst(primaryAttribute,
            value: value,
            context: context,
            elseThen: swi_createEntityInContext)
            .swi_updateWith(json)
      }
   }
}

//MARK:Private

extension NSManagedObject {
   class var swi_entityName: String {
      return String(self)
   }
   class func swi_createEntityInContext(context: NSManagedObjectContext) -> NSManagedObject {
      return NSEntityDescription
         .insertNewObjectForEntityForName(swi_entityName, inManagedObjectContext: context)
   }
   class func swi_findFirst(value: AnyObject,
      key: String,
      context: NSManagedObjectContext) -> NSManagedObject? {
         let request = NSFetchRequest()
         request.entity = NSEntityDescription
            .entityForName(swi_entityName, inManagedObjectContext: context)
         request.predicate = NSPredicate(format: "%K == '\(value)'", key)
         do {
            let data = try context.executeFetchRequest(request)
            return data.first as? NSManagedObject
         } catch {
            print("NSManagedObject swi_findFirst ERROR:\(error)")
            return .None
         }
   }
   class func swi_ifFindFirst(key: String,
      value: AnyObject,
      context: NSManagedObjectContext,
      elseThen: NSManagedObjectContext -> NSManagedObject ) -> NSManagedObject {
         if let first = swi_findFirst(value, key: key, context: context) {
            return first
         } else {
            return elseThen(context)
         }
   }
}

extension NSManagedObject {
   func swi_updateWith(json: JSONDictionary) throws -> NSManagedObject {
      do {
         try swi_updatePropertiesWith(json)
         try swi_updateRelationsWith(json)
      } catch {
         throw error
      }
      return self
   }
   private func swi_updatePropertiesWith(json: JSONDictionary) throws -> Void {
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
   private func swi_updateRelationsWith(json: JSONDictionary) throws -> Void {
      try entity.relationshipsByName.forEach { (tuple) -> () in
         try swi_updateRelationshipWith
            <^> JSONObject -<< json[classForCoder.map[tuple.0] ?? tuple.0]
            <*> tuple.0
         try swi_updateRelationshipsWith
            <^> JSONObjects -<< json[classForCoder.map[tuple.0] ?? tuple.0]
            <*> tuple.0
      }
   }
   private func swi_updateRelationshipWith(json: JSONDictionary) -> (key: String) throws -> Void {
      return { key in
         guard let relation = self.entity.relationshipsByName[key],
            entity = relation.destinationEntity,
            name = entity.managedObjectClassName,
            clas = NSClassFromString(name) as? NSManagedObject.Type,
            value = json[clas.map[clas.primaryAttribute] ?? clas.primaryAttribute],
            context = self.managedObjectContext
            where relation.toMany == false else {
               throw ImportError.RelationTypeMismatch(entityName: self.classForCoder.swi_entityName,
                  expected: "To one",
                  got: "To many")
         }
         let obj = try clas.swi_ifFindFirst(clas.primaryAttribute,
            value: value,
            context: context,
            elseThen: clas.swi_createEntityInContext)
            .swi_updateWith(json)
         self.setValue(obj, forKey: key) // setting value for relationship
      }
   }
   private func swi_updateRelationshipsWith(array: [JSONDictionary])
      -> (key: String) throws -> Void {
      return { key in
         guard let relation = self.entity.relationshipsByName[key],
            entity = relation.destinationEntity,
            name = entity.managedObjectClassName,
            clas = NSClassFromString(name) as? NSManagedObject.Type
            where relation.toMany else {
               throw ImportError.RelationTypeMismatch(entityName: self.classForCoder.swi_entityName,
                  expected: "To many",
                  got: "To one")
         }
         try array.forEach {
            guard let value = $0[clas.map[clas.primaryAttribute] ?? clas.primaryAttribute],
               context = self.managedObjectContext else {
                  return
            }
            let obj = try clas.swi_ifFindFirst(clas.primaryAttribute,
               value: value,
               context: context,
               elseThen: clas.swi_createEntityInContext)
               .swi_updateWith($0)
            let relationName = relation.name.swi_capitalizedFirstCharacterString()
            let selector = Selector("add\(relationName)Object:")
            assert(self.respondsToSelector(selector))//this should not be happened
            if self.respondsToSelector(selector) {
               self.performSelector(selector, withObject: obj)
            }
         }
      }
   }
   private func swi_updateAttribute(att: NSAttributeDescription)
      -> (value: AnyObject)
      -> (key: String) throws -> NSManagedObject {
         return { value in
            return { key in
               if att.attributeValueClassName == NSStringFromClass(value.classForCoder) {
                  self.setValue(value, forKey: key)
               } else {
                  throw ImportError.TypeMismatch(entityName: self.classForCoder.swi_entityName,
                     expectedType: att.attributeValueClassName ?? "",
                     type: value.dynamicType,
                     key: key)
               }
               return self
            }
         }
   }
}

extension String {
   func swi_capitalizedFirstCharacterString() -> String {
      if !isEmpty {
         let firstChar = substringToIndex(startIndex.successor()).capitalizedString
         return firstChar + substringFromIndex(startIndex.successor())
      } else {
         return ""
      }
   }
}
