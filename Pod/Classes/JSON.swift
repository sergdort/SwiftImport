//
//  JSON.swift
//  CoreDataImporter
//
//  Created by Segii Shulga on 8/28/15.
//  Copyright © 2015 Sergey Shulga. All rights reserved.
//

public typealias JSON = AnyObject
public typealias JSONDictionary = Dictionary<String, JSON>
public typealias JSONArray = Array<JSON>

public func JSONObjectWithData(data: NSData) -> AnyObject? {
   do { return try NSJSONSerialization.JSONObjectWithData(data, options: []) }
   catch { return .None }
}

public func JSONString(object: JSON) -> String? {
   return object as? String
}

public func JSONObject(object: JSON) -> JSONDictionary? {
   return object as? JSONDictionary
}

public func JSONObjects(object:JSON) -> [JSONDictionary]? {
   return object as? [JSONDictionary]
}
