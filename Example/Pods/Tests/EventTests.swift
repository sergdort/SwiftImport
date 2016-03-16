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

class EventTests: CoreDataTestCase {
   
   func test_shouldNotImportWrongEvent() {
      let event = curry(SwiftImport<Event>.importObjects)
         <^> JSONObjects -<< JSONFromFileName -<< "WrongEvent"
         <*> NSManagedObjectContext.MR_defaultContext()
      expect(event?.value).to(beNil())
   }
   
   func test_importEvents() {
      let events = curry(SwiftImport<Event>.importObjects)
         <^> JSONObjects -<< JSONFromFileName -<< "Events"
         <*> NSManagedObjectContext.MR_defaultContext()
      expect(events?.value?[0].eventId).to(equal(1))
      expect(events?.value?[0].name).to(equal("WWDC 2015"))
      expect(events?.value?[0].locationName).to(equal("San Francisco"))
      expect(events?.value?[0].address).to(equal("Place # X"))
      expect(events?.value?[1].eventId).to(equal(2))
      expect(events?.value?[1].name).to(equal("WWDC 2014"))
      expect(events?.value?[1].locationName).to(equal("San Francisco"))
      expect(events?.value?[1].address).to(equal("Place # X1"))
   }
   
   func test_ShouldImportEvent() {
      let event = curry(SwiftImport<Event>.importObject)
         <^> JSONObject -<< JSONFromFileName -<< "Event"
         <*> NSManagedObjectContext.MR_defaultContext()
      let user = event?.value?.participants?.anyObject() as? User
      let homeCity = user?.homeCity
      expect(event).toNot(beNil())
      expect(event?.value?.locationName).toNot(beNil())
      expect(event?.value?.eventId).toNot(beNil())
      expect(event?.value?.address).toNot(beNil())
      expect(event?.value?.name).toNot(beNil())
      expect(event?.value?.participants).toNot(beNil())
      expect(event?.value?.participants?.count).to(equal(2))
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
      expect(event?.error).to(beNil())
   }
}
