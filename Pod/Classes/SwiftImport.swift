//
//  CoreDataImporter.swift
//  CoreDataImporter
//
//  Created by Segii Shulga on 8/28/15.
//  Copyright © 2015 Sergey Shulga. All rights reserved.
//

import Foundation
import CoreData

public enum ImportError:ErrorType {
   case InvalidJSON
}

extension ImportError: CustomStringConvertible {
   public var description: String {
      switch self {
      case .InvalidJSON: return "Invalid JSON"
      }
   }
}

public protocol JSONToEntityMapable {
   static var map:[String:String] {get} 
   static var relatedByAttribute:String {get}
   static var relatedJsonKey:String {get}
}

public protocol Importable {
   typealias T = Self
   static func importIn(context:NSManagedObjectContext) -> (json:JSONDictionary) throws -> T
}

public class SwiftImport<Element:NSManagedObject> {
   
   public class func importObject(context:NSManagedObjectContext) -> (dict:JSONDictionary) throws -> Element {
      return { dict in
         do {
            return try Element.importIn(context)(json: dict) as! Element
         } catch {
            throw error
         }
      }
   }
   

}

extension SwiftImport {
   public class func importObjects(context:NSManagedObjectContext) -> (array:[JSONDictionary]) throws -> [Element] {
      return { array in
         return try array.map(importObject(context))
      }
   }
}

