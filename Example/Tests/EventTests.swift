//
//  EventTests.swift
//  SwiftImport
//
//  Created by Segii Shulga on 8/29/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import MagicalRecord
import SwiftImport

class EventTests: QuickSpec {
    
   override func spec() {
      
      describe("EventTests") { () -> () in
         
         beforeEach({ () -> () in
            MagicalRecord.setDefaultModelFromClass(self.dynamicType)
            MagicalRecord.setupCoreDataStackWithInMemoryStore()
         })
         
         afterEach({ () -> () in
            MagicalRecord.cleanUp()
         })
         
         it("should throw", closure: { () -> () in
//            WrongEvent
            guard let json = JSONFromFileName -<< "WrongEvent" as? [JSONDictionary] else {
               XCTAssert(false)
               return
            }
            
            do {
               _ = try SwiftImport<Event>.importObjects(NSManagedObjectContext.MR_defaultContext())(array: json)
               XCTAssert(false)
            } catch {
               XCTAssert(true)
            }

         })
         
         it("should import Event", closure: { () -> () in
            
            do {
               
               if let events = try SwiftImport<Event>.importObjects <^> NSManagedObjectContext.MR_defaultContext() <*> JSONObjects -<< JSONFromFile -<< "Events"  {
                  
                  expect(events[0].eventId).to(equal(1))
                  expect(events[0].name).to(equal("WWDC 2015"))
                  expect(events[0].locationName).to(equal("San Francisco"))
                  expect(events[0].address).to(equal("Place # X"))
                  
                  expect(events[1].eventId).to(equal(2))
                  expect(events[1].name).to(equal("WWDC 2014"))
                  expect(events[1].locationName).to(equal("San Francisco"))
                  expect(events[1].address).to(equal("Place # X1"))
               }
               
            } catch {
               XCTAssert(false)
               return
            }
         })
               
      }
      
   }
    
}
