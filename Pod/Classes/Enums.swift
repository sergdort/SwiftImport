//
//  Enums.swift
//  Pods
//
//  Created by Segii Shulga on 3/7/16.
//
//

import Foundation

public enum ImportError: ErrorType {
   case MissingPrimaryAttribute(entityName: String)
   case TypeMismatch(entityName: String,
      expectedType: String,
      type: AnyObject.Type, key:String)
   case CastingError(object: AnyObject, targetType: Any.Type)
   case RelationTypeMismatch(entityName: String, expected: String, got: String)
   case Custom(String)
}

extension ImportError: CustomStringConvertible {
   public var description: String {
      switch self {
      case let .MissingPrimaryAttribute(entityName):
         return "Missing primary attribute for entity: \(entityName)"
      case let .TypeMismatch(tuple):
         return "Type mismatch. Expected type:\(tuple.expectedType)" +
         " got type: \(tuple.type) for key: \(tuple.key) for entity: \(tuple.entityName)"
      case .CastingError(let tuple):
         return "Castring error object: \(tuple.object) to \(tuple.targetType)"
      case let .RelationTypeMismatch(tuple):
         return "Relation type missmatch, expected \(tuple.expected)"
         + " got \(tuple.got) for entity \(tuple.entityName)"
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
