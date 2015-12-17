//
//  Protocols.swift
//  Pods
//
//  Created by Segii Shulga on 12/17/15.
//
//
import Foundation
import CoreData.NSManagedObjectContext

public protocol JSONToEntityMapable {
   static var map:[String:String] {get}
   static var relatedByAttribute:String {get}
}

public protocol Importable {
   typealias T = Self
   static func importIn(context:NSManagedObjectContext) -> (json:JSONDictionary) throws -> T
}
