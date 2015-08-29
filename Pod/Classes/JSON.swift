//
//  JSON.swift
//  CoreDataImporter
//
//  Created by Segii Shulga on 8/28/15.
//  Copyright © 2015 Sergey Shulga. All rights reserved.
//

import Foundation

public typealias JSON = AnyObject
public typealias JSONDictionary = Dictionary<String, JSON>
public typealias JSONArray = Array<JSON>



public func JSONFromFile(path:String) -> JSON? {
   return NSData(contentsOfFile: path) >>- JSONObjectWithData
}
public func JSONObjectWithData(data: NSData) -> AnyObject? {
   do { return try NSJSONSerialization.JSONObjectWithData(data, options: []) }
   catch { return .None }
}

public func JSONString(object: JSON) -> String? {
   return object as? String
}

public func JSONNumber(object: JSON) -> NSNumber? {
   return object as? NSNumber
}

public func JSONObjects(object: JSON) -> JSONArray? {
   return object as? JSONArray
}

public func JSONObject(object: JSON) -> JSONDictionary? {
   return object as? JSONDictionary
}