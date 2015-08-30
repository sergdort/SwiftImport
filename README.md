# SwiftImport

[![CI Status](http://img.shields.io/travis/sshulga/SwiftImport.svg?style=flat)](https://travis-ci.org/sshulga/SwiftImport)
[![Version](https://img.shields.io/cocoapods/v/SwiftImport.svg?style=flat)](http://cocoapods.org/pods/SwiftImport)
[![License](https://img.shields.io/cocoapods/l/SwiftImport.svg?style=flat)](http://cocoapods.org/pods/SwiftImport)
[![Platform](https://img.shields.io/cocoapods/p/SwiftImport.svg?style=flat)](http://cocoapods.org/pods/SwiftImport)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Usage
```swift
import SwiftImport

extension User {

    @NSManaged var lastName: String?
    @NSManaged var name: String?
    @NSManaged var userId: NSNumber?
    @NSManaged var createdEvents: NSSet?
    @NSManaged var homeCity: City?

}

extension User { //Extend JSONToEntityMapable protocol
   override class func mappedKeys() -> [String : String] { // ["jsonKey" : "mappedKey"]
      return [ "id" : "userId", "name" : "name", "last_name" : "lastName", "home_city" : "homeCity", "events" : "createdEvents"]
   }

   override class func relatedByAttribute() -> String {// The unique key of object
      return "userId"
   }
   
   override class func relatedJsonKey() -> String {// The unique key of object in json
      return "id"
   }
   
}

...

do {
	 let users = try SwiftImport<User>.importObjects <^> json <*> context 
} catch {
	//handle error here (ImportError.InvalidJSON)
}

...

or if u prefer normal  sintax ;)

do {
    let users = try SwiftImport<User>.importObjects(json)(context: context)
} catch {
	handle error
}

```

## Installation (Not yet published)

SwiftImport is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "SwiftImport"
```

## Author

sshulga, sergdort@gmail.com

## License

SwiftImport is available under the MIT license. See the LICENSE file for more info.
