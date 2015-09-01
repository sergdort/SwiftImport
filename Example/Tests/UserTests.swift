//
//  SHUJSONKitTests.swift
//  SHUJSONKitTests
//
//  Created by Segii Shulga on 8/28/15.
//  Copyright © 2015 Sergey Shulga. All rights reserved.
//

import XCTest
import Quick
import Nimble
import MagicalRecord
import SwiftImport


class JSONFileReader { }

func JSONFromFileName(name: String) -> JSON? {
   let path = NSBundle(forClass: JSONFileReader.self).pathForResource(name, ofType: "json")
   return JSONFromFile -<< path
}

class UserTests: QuickSpec {
   
   override func spec() {
      
      describe("User import") { () -> () in
         
         beforeEach({ () -> () in
            MagicalRecord.setDefaultModelFromClass(self.dynamicType)
            MagicalRecord.setupCoreDataStackWithInMemoryStore()
         })
         
         afterEach({ () -> () in
            MagicalRecord.cleanUp()
         })
         
         it("Should have context", closure: { () -> () in
            
            expect(NSManagedObjectContext.MR_defaultContext()).toNot(beNil())
            
         })
         
         it("should import Users", closure: { () -> () in
            do {
               if let users = try SwiftImport<User>.importObjects <^> JSONObjects -<< JSONFromFileName -<< "Users" <*> NSManagedObjectContext.MR_defaultContext() {
                  
                  expect(users[0].userId).to(equal(1))
                  expect(users[0].name).to(equal("John"))
                  expect(users[0].lastName).to(equal("Snow"))
                  expect(users[0].homeCity).toNot(beNil())
                  expect(users[0].homeCity?.cityId).to(equal(1))
                  expect(users[0].homeCity?.name).to(equal("Winterfell"))
                  expect(users[0].createdEvents?.count).toNot(equal(0))
                  
                  expect(users[1].userId).to(equal(2))
                  expect(users[1].name).to(equal("Tirion"))
                  expect(users[1].lastName).to(equal("Lannister"))
                  expect(users[1].homeCity?.cityId).to(equal(2))
                  expect(users[1].homeCity?.name).to(equal("Lannisport"))
                  expect(users[0].createdEvents?.count).toNot(equal(0))
                  
               } else {
                  XCTAssert(false)
               }
            } catch {
               XCTAssert(false)
               return
            }
         })
         
         it("should create user", closure: { () -> () in
            do {
               let user = try SwiftImport<User>.importObject <^> JSONObject -<< JSONFromFileName -<< "User" <*> NSManagedObjectContext.MR_defaultContext()
               print(user)
               let event = user?.createdEvents?.anyObject() as? Event
               let partisipant = event?.participants?.anyObject() as? User
               let partisipantCreatedEvent = partisipant?.createdEvents?.anyObject() as? Event
               
               expect(event).toNot(beNil())
               expect(partisipant).toNot(beNil())
               
               expect(partisipant?.userId).to(equal(2))
               expect(partisipant?.name).to(equal("Tirion"))
               expect(partisipant?.homeCity?.cityId).to(equal(2))
               expect(partisipant?.homeCity?.name).to(equal("Lannisport"))
               
               expect(partisipantCreatedEvent?.eventId).to(equal(3))
               expect(partisipantCreatedEvent?.name).to(equal("Cool event"))
               expect(partisipantCreatedEvent?.locationName).to(equal("Cool location"))
               
            } catch {
               XCTAssert(false, "\(error)")
               return
            }
         })
         
         it("should throw error", closure: { () -> () in
            do {
               _ = try SwiftImport<User>.importObjects <^> JSONObjects -<< JSONFromFileName -<< "WrongUser" <*> NSManagedObjectContext.MR_defaultContext()
               XCTAssert(false)
            } catch {
               XCTAssert(true)
            }
         })
      
      }
   
   }

}
