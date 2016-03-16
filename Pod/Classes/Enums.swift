//
//  Enums.swift
//  Pods
//
//  Created by Segii Shulga on 3/7/16.
//
//

import Foundation

public enum ImportError: ErrorType {
   case MissingKey(String)
   case TypeMismatch(value:AnyObject, key:String)
   case CastingError(object: AnyObject, targetType: Any.Type)
   case RelationTypeMismatch(expected: String, got: String)
   case Custom(String)
}

extension ImportError: CustomStringConvertible {
   public var description: String {
      switch self {
      case let .MissingKey(key):
         return "MissingKey \(key)"
      case let .TypeMismatch(tuple):
         return "TypeMismatch class:\(tuple.value.classForCoder)" +
         " value: \(tuple.value) for key: \(tuple.key)"
      case .CastingError(let tuple):
         return "Castring error object: \(tuple.object) to \(tuple.targetType)"
      case let .RelationTypeMismatch(tuple):
         return "Relation type missmatch, expected \(tuple.expected) got \(tuple.got)"
      case .Custom(let value):
         return value
      }
   }
}

public enum Imported<T> {
   case Some(T)
   case Failure(ImportError)
}

extension Imported {
   public var value: T? {
      switch self {
      case .Some(let v):
         return v
      case .Failure(_):
         return .None
      }
   }
   public var error: ImportError? {
      switch self {
      case .Failure(let e):
         return e
      case .Some(_):
         return .None
      }
   }
}

extension Imported: CustomStringConvertible {
   public var description: String {
      switch self {
      case .Some(let value):
         return String(value)
      case .Failure(let error):
         return error.description
      }
   }
}
