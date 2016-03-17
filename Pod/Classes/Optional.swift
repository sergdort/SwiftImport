//
//  Optional.swift
//  CoreDataImporter
//
//  Created by Segii Shulga on 8/28/15.
//  Copyright © 2015 Sergey Shulga. All rights reserved.
//

extension Optional {
   func apply<U>(f: (Wrapped -> U)?) -> U? {
      return f.flatMap { self.map($0) }
   }
   func apply<U>(f: (Wrapped throws -> U)?) throws -> U? {
      do {
         return try f.flatMap {
            do {
               return try self.map($0)
            } catch {
               throw error
            }
         }
      } catch {
         throw error
      }
   }
}
