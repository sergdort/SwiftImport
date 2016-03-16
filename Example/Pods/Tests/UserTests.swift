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



class UserTests: CoreDataTestCase {
   
   func test_shouldImportUsers() {
      if let importedUsers = curry(SwiftImport<User>.importObjects)
         <^> JSONObjects -<< JSONFromFileName -<< "Users"
         <*> NSManagedObjectContext.MR_defaultContext(),
         users = importedUsers.value {
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
         XCTFail()
      }
   }
   
   func test_shouldImportUser() {
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
   
   func test_shouldFailWithError() {
      let imported = curry(SwiftImport<User>.importObjects)
         <^> JSONObjects -<< JSONFromFileName -<< "WrongUser"
         <*> NSManagedObjectContext.MR_defaultContext()

      expect(imported?.error).toNot(beNil())
   }
   
   func test_shouldNotImport() {
      let user = curry(SwiftImport<User>.importObject)
         <^> JSONObject -<< JSONFromFileName -<< "UserWrongRelations"
         <*> NSManagedObjectContext.MR_defaultContext()
      expect(user?.error).toNot(beNil())
   }
}
