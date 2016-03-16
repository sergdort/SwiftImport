//
//  TestHelpers.swift
//  SwiftImport
//
//  Created by Segii Shulga on 12/15/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import Foundation
import SwiftImport

class JSONFileReader { }

public func curry<A, B>(function: (A) -> B) -> A -> B {
   return { `a` in function(`a`) }
}

public func curry<A, B, C>(function: (A, B) -> C) -> A -> B -> C {
   return { `a` in { `b` in function(`a`, `b`) } }
}

public func JSONFromFile(path: String) -> JSON? {
   return JSONObjectWithData -<< NSData(contentsOfFile: path)
}

func JSONFromFileName(name: String) -> AnyObject? {
   let path = NSBundle(forClass: JSONFileReader.self).pathForResource(name, ofType: "json")
   return JSONFromFile -<< path
}

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
