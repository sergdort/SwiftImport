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