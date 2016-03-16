//
//  Functions.swift
//  Pods
//
//  Created by Segii Shulga on 3/7/16.
//
//

import Foundation

func castOrThrow<T>(resultType: T.Type, _ object: AnyObject) throws -> T {
   guard let returnValue = object as? T else {
      throw ImportError.CastingError(object: object, targetType: resultType)
   }
   return returnValue
}

func curry<A, B, C>(function: (A, B) -> C) -> A -> B -> C {
   return { `a` in { `b` in function(`a`, `b`) } }
}

func lazyAssociatedProperty<T: AnyObject>(host: AnyObject,
   key: UnsafePointer<Void>,
   factory: () -> T) -> T {
   return objc_getAssociatedObject(host, key) as? T ?? {
      let associatedProperty = factory()
      objc_setAssociatedObject(host,
         key,
         associatedProperty, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
      return associatedProperty
      }()
}
