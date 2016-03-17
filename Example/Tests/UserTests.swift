//
//  SHUJSONKitTests.swift
//  SHUJSONKitTests
//
//  Created by Segii Shulga on 8/28/15.
//  Copyright © 2015 Sergey Shulga. All rights reserved.
//

import XCTest
import Nimble
import MagicalRecord


class UserTests: CoreDataTestCase {
   
   func test_should_import_users() {
      if let users = curry(SwiftImport<User>.importObjects)
         <^> JSONObjects -<< JSONFromFileName -<< "Users"
         <*> NSManagedObjectContext.MR_defaultContext()  {
            
            expect(users.value?[0].userId).to(equal(1))
            expect(users.value?[0].name).to(equal("John"))
            expect(users.value?[0].lastName).to(equal("Snow"))
            expect(users.value?[0].homeCity).toNot(beNil())
            expect(users.value?[0].homeCity?.cityId).to(equal(1))
            expect(users.value?[0].homeCity?.name).to(equal("Winterfell"))
            expect(users.value?[0].createdEvents?.count).toNot(equal(0))
            
            expect(users.value?[1].userId).to(equal(2))
            expect(users.value?[1].name).to(equal("Tirion"))
            expect(users.value?[1].lastName).to(equal("Lannister"))
            expect(users.value?[1].homeCity?.cityId).to(equal(2))
            expect(users.value?[1].homeCity?.name).to(equal("Lannisport"))
            expect(users.value?[0].createdEvents?.count).toNot(equal(0))
            
      } else {
         XCTFail()
      }
   }
   
   func test_should_import_user() {
      let user = curry(SwiftImport<User>.importObject)
         <^> JSONObject -<< JSONFromFileName -<< "User"
         <*> NSManagedObjectContext.MR_defaultContext()
      let event = user?.value?.createdEvents?.anyObject() as? Event
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
   }
   
   func test_should_not_import() {
      let imported = curry(SwiftImport<User>.importObjects)
            <^> JSONObjects -<< JSONFromFileName -<< "WrongUser"
            <*> NSManagedObjectContext.MR_defaultContext()
      
      expect(imported?.error).toNot(beNil())
   }
}
