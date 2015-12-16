//
//  ExtensionTests.swift
//  SwiftImport
//
//  Created by Segii Shulga on 8/30/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import XCTest
import Quick
import Nimble
import MagicalRecord
import SwiftImport


class ExtensionTests:QuickSpec {
   override func spec() {
      describe("ExtensionTests") { () -> Void in
         it("Should capitalize 1st char", closure: { () -> () in
            let str = "helloWorld"
            expect(str.swi_capitalizedFirstCharacterString()).to(equal("HelloWorld"))
         })
         it("should reurn nil", closure: { () -> () in
            let str = ""
            expect(str.swi_capitalizedFirstCharacterString()).to(beNil())
         })
         
         it("should", closure: { () -> () in
            let str = "  str";
            let cap = str.swi_capitalizedFirstCharacterString()
            expect(cap).to(equal(str))
         })
      }
   }
}
