//
//  CoreDataTestCase.swift
//  SwiftImport
//
//  Created by Segii Shulga on 3/7/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import XCTest
import MagicalRecord

class CoreDataTestCase: XCTestCase {
   
   override func setUp() {
      super.setUp()
      MagicalRecord.setDefaultModelFromClass(self.dynamicType)
      MagicalRecord.setupCoreDataStackWithInMemoryStore()
   }
   
   override func tearDown() {
      super.tearDown()
      MagicalRecord.cleanUp()
   }
   
}