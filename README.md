# SwiftImport

[![CI Status](http://img.shields.io/travis/sshulga/SwiftImport.svg?style=flat)](https://travis-ci.org/sergdort/SwiftImport)
[![Version](https://img.shields.io/cocoapods/v/SwiftImport.svg?style=flat)](http://cocoapods.org/pods/SwiftImport)
[![License](https://img.shields.io/cocoapods/l/SwiftImport.svg?style=flat)](http://cocoapods.org/pods/SwiftImport)
[![Platform](https://img.shields.io/cocoapods/p/SwiftImport.svg?style=flat)](http://cocoapods.org/pods/SwiftImport)

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

extension User {
   override class func mapped() -> [String : String] { // if keys are the same dont need to provide map
      return [ "userId" : "id", "lastName" : "last_name", "homeCity" : "home_city", "createdEvents" : "events"]
   }

   override class func relatedByAttribute() -> String {
      return "userId"
   }
   
   override class func relatedJsonKey() -> String {
      return "id"
   }
   
}

...

do {

    let data = //...data from responce or something else
    let user = try SwiftImport<User>.importObject <^> JSONObject -<< JSONObjectWithData -<< data <*> context
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

## Installation

SwiftImport is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "SwiftImport"
```

## TODO

- Use [Runes](https://github.com/thoughtbot/runes) 

## Author

sshulga, sergdort@gmail.com

## License

SwiftImport is available under the MIT license. See the LICENSE file for more info.
