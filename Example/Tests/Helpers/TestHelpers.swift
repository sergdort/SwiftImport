//
//  TestHelpers.swift
//  SwiftImport
//
//  Created by Segii Shulga on 12/15/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import Foundation

class JSONFileReader { }

func JSONFromFile(path:String) -> JSON? {
   return JSONObjectWithData -<< NSData(contentsOfFile: path)
}

func JSONFromFileName(name: String) -> AnyObject? {
   let path = NSBundle(forClass: JSONFileReader.self).pathForResource(name, ofType: "json")
   return JSONFromFile -<< path
}
