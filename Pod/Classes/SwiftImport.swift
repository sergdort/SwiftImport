//
//  CoreDataImporter.swift
//  CoreDataImporter
//
//  Created by Segii Shulga on 8/28/15.
//  Copyright © 2015 Sergey Shulga. All rights reserved.
//

import Foundation
import CoreData

public class SwiftImport<Element:NSManagedObject> {
   /**
    If object assosiated with json does not exist in the storage it will be created,
    otherwise it will be fetched by the relatedByAttribute and updated with values in the json
    - parameter json:  JSONDictionary that will be imported
    - parameter context: NSManagedObjectContext associated with the import
    - returns: Imported<Element>
    */
   public class func importObject(json: [String: AnyObject],
      context: NSManagedObjectContext) -> Imported<Element> {
      do {
         let element = try castOrThrow(Element.self, Element.importIn(context)(json: json))
         return .Some(element)
      } catch let error as ImportError {
         return .Failure(error)
      } catch {
         return .Failure(.Custom("Unknown error"))
      }
   }
}
extension SwiftImport {
   /**
    If objects assosiated with json array does not exist in the storage they will be created,
    otherwise they will be fetched by the relatedByAttribute
    and updated with values in the json array
    - parameter objects: array of JSONDictionary
    - parameter context: NSManagedObjectContext associated with the import
    - returns: Imported<[Element]>
    */
   public class func importObjects(objects: [[String: AnyObject]],
      context: NSManagedObjectContext) -> Imported<[Element]> {
      do {
         let elements = try castOrThrow(Array<Element>.self, objects.map(Element.importIn(context)))
         return .Some(elements)
      } catch let error as ImportError {
         return .Failure(error)
      } catch {
         return .Failure(.Custom("Unknown error"))
      }
   }
}
