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
            do {
               let event = try SwiftImport<Event>.importObjects
                  <^> NSManagedObjectContext.MR_defaultContext()
                  <*> JSONObjects -<< JSONFromFileName -<< "WrongEvent"
               
               expect(event).to(beNil())
            } catch {
               XCTAssert(true)
            }

         })
         
         it("should import Events", closure: { () -> () in
            
            do {
               
               let events = try SwiftImport<Event>.importObjects
                  <^> NSManagedObjectContext.MR_defaultContext()
                  <*> JSONObjects -<< JSONFromFileName -<< "Events"
                  
                  expect(events?[0].eventId).to(equal(1))
                  expect(events?[0].name).to(equal("WWDC 2015"))
                  expect(events?[0].locationName).to(equal("San Francisco"))
                  expect(events?[0].address).to(equal("Place # X"))
                  
                  expect(events?[1].eventId).to(equal(2))
                  expect(events?[1].name).to(equal("WWDC 2014"))
                  expect(events?[1].locationName).to(equal("San Francisco"))
                  expect(events?[1].address).to(equal("Place # X1"))
            } catch {
               XCTAssert(false)
            }
         })
         
         it("should import event", closure: { () -> () in
            do {
               let event = try SwiftImport<Event>.importObject
                  <^> NSManagedObjectContext.MR_defaultContext()
                  <*> JSONObject -<< JSONFromFileName -<< "Event"
               
               let user = event?.participants?.anyObject() as? User
               
               let homeCity = user?.homeCity
               
               expect(event).toNot(beNil())
               expect(event?.locationName).toNot(beNil())
               expect(event?.eventId).toNot(beNil())
               expect(event?.address).toNot(beNil())
               expect(event?.name).toNot(beNil())
               expect(event?.participants).toNot(beNil())
               expect(event?.participants?.count).to(equal(2))
               
               expect(user).toNot(beNil())
               expect(user?.userId).toNot(beNil())
               expect(user?.name).toNot(beNil())
               expect(user?.lastName).toNot(beNil())
               expect(user?.homeCity).toNot(beNil())
               expect(user?.createdEvents).toNot(beNil())
               expect(user?.createdEvents?.count).to(equal(2))
               
               expect(homeCity).toNot(beNil())
               expect(homeCity?.cityId).toNot(beNil())
               expect(homeCity?.name).toNot(beNil())
               
            } catch {
               XCTAssert(false)
               return
            }
         })
         
      }
      
   }
    
}
