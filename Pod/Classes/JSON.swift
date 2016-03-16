//
//  JSON.swift
//  CoreDataImporter
//
//  Created by Segii Shulga on 8/28/15.
//  Copyright © 2015 Sergey Shulga. All rights reserved.
//
import Foundation

typealias JSON = AnyObject
typealias JSONDictionary = Dictionary<String, JSON>
typealias JSONArray = Array<JSON>

func JSONObjectWithData(data: NSData) -> AnyObject? {
   do {
      return try NSJSONSerialization.JSONObjectWithData(data, options:[])
   } catch {
      return .None
   }
}

func JSONObject(object: JSON) -> JSONDictionary? {
   return object as? JSONDictionary
}

func JSONObjects(object: JSON) -> [JSONDictionary]? {
   return object as? [JSONDictionary]
}
