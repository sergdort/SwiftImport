//
//  Operators.swift
//  CoreDataImporter
//
//  Created by Segii Shulga on 8/28/15.
//  Copyright © 2015 Sergey Shulga. All rights reserved.
//

import Foundation

infix operator <^> { associativity left precedence 130 }
infix operator <*> { associativity left precedence 130 }
infix operator >>- { associativity left precedence 150 }
infix operator -<< { associativity right precedence 150 }
infix operator <<< { associativity right precedence 160 }
infix operator >>> { associativity left precedence 160 }

func <^> <T, U>(f: T -> U, a: T?) -> U? {
   return a.map(f)
}

func <^> <T, U>(f: T throws -> U, a: T?) -> U? {
   do {
     return try a.map(f)
   } catch {
      return .None
   }
}

func <*> <T, U>(f: (T -> U)?, a: T?) -> U? {
   return a.apply(f)
}

func <*> <T, U>(f: (T throws -> U)?, a: T?) throws -> U? {
   do {
      return try a.apply(f)
   } catch {
      throw error
   }
}

func >>- <T, U>(a: T?, f: T -> U?) -> U? {
   return a.flatMap(f)
}

func >>- <T, U>(a: T?, f: T throws -> U?) throws -> U? {
   do {
      return try a.flatMap(f)
   } catch {
      throw error
   }
}

func -<< <T, U>(f: T -> U?, a: T?) -> U? {
   return a.flatMap(f)
}

func -<< <T, U>(f: T throws -> U?, a: T?) throws -> U? {
   do {
      return try a.flatMap(f)
   } catch {
      throw error
   }
}
