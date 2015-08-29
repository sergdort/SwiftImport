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



class SHUJSONKitTests: QuickSpec {
    
   override func spec() {
      
      describe("User import") { () -> () in
         
         beforeEach({ () -> () in
            MagicalRecord.setDefaultModelFromClass(self.dynamicType)
            MagicalRecord.setupCoreDataStackWithInMemoryStore()
         })
         
         it("Should have context", closure: { () -> () in
            
            expect(NSManagedObjectContext.MR_defaultContext()).toNot(equal(nil))
            
         })
         
         it("should import Users", closure: { () -> () in
            guard let json = JSONFromFileName -<< "User" as? [JSONDictionary] else {
               XCTAssert(false)
               return
            }
            do {
               
               if let users = try CoreDataImporter<User>.importObjects <^> json <*> NSManagedObjectContext.MR_defaultContext() {
                  for user in users {
                     expect(user.userId).toNot(equal(nil))
                     expect(user.name).toNot(equal(nil))
                  }
                  
                  expect(users[0].userId).to(equal(1))
                  expect(users[0].name).to(equal("John"))
                  expect(users[0].lastName).to(equal("Snow"))
                  expect(users[1].userId).to(equal(2))
                  expect(users[1].name).to(equal("Tirion"))
                  expect(users[1].lastName).to(equal("Lannister"))
               } else {
                  XCTAssert(false)
               }
            } catch {
               XCTAssert(false)
               return
            }
         })
         
         it("should throw error", closure: { () -> () in
            guard let json = JSONFromFileName -<< "WrongUser" as? [JSONDictionary] else {
               XCTAssert(false)
               return
            }
            do {
               let users = try CoreDataImporter<User>.importObjects(json)(context: NSManagedObjectContext.MR_defaultContext())
               XCTAssert(false)
            } catch {
               XCTAssert(true)
            }
         })
      
      }
   
   }

}
