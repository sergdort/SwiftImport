//
//  DummyEntityTests.swift
//  SwiftImport
//
//  Created by Segii Shulga on 12/15/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import XCTest
import Nimble
import MagicalRecord

class DummyEntityTests: CoreDataTestCase {
   
   func test_should_import() {
      let dummy = curry(SwiftImport<DummyEntity>.importObject)
         <^> JSONObject -<< JSONFromFileName -<< "DummyEntity"
         <*> NSManagedObjectContext.MR_defaultContext()
      
      expect(dummy?.value?.entityId).to(equal("1"))
      expect(dummy?.value?.name).to(equal("Dummy"))
      expect(dummy?.value?.secondName).to(equal("Entity"))
   }
   
   func should_throw_error() {
      let imported = curry(SwiftImport<DummyEntity>.importObject)
         <^> JSONObject -<< JSONFromFileName -<< "DumyEntityWithWrongValue"
         <*> NSManagedObjectContext.MR_defaultContext()
      
      expect(imported?.error).toNot(beNil())
   }   
}
