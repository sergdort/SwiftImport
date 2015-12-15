//
//  DummyEntityTests.swift
//  SwiftImport
//
//  Created by Segii Shulga on 12/15/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import XCTest
import Quick
import Nimble
import MagicalRecord
import SwiftImport

class DummyEntityTests: QuickSpec {
   
   override func spec() {
      
      describe("DummyEntityTests") { () -> Void in
         beforeEach({ () -> () in
            MagicalRecord.setDefaultModelFromClass(self.dynamicType)
            MagicalRecord.setupCoreDataStackWithInMemoryStore()
         })
         
         afterEach({ () -> () in
            MagicalRecord.cleanUp()
         })
         
         it("should import correctly", closure: { () -> () in
            do {
               let dummy = try SwiftImport<DummyEntity>.importObject <^> NSManagedObjectContext.MR_defaultContext() <*> JSONObject -<< JSONFromFileName -<< "DummyEntity"
               
               expect(dummy?.entityId).to(equal(1))
               expect(dummy?.name).to(equal("Dummy"))
               expect(dummy?.secondName).to(equal("Entity"))
            } catch {
               XCTAssert(false)
            }
         })
         
      }
      
   }
   
}
