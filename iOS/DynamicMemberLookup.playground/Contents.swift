import Foundation
import SwiftUI

/// https://www.hackingwithswift.com/articles/134/how-to-use-dynamiccallable-in-swift
///
@dynamicMemberLookup
struct Person {
    subscript(dynamicMember member: String) -> String {
        let properties = ["name": "Taylor Swift", "city": "Nashville"]
        return properties[member, default: ""]
    }
    
    subscript(dynamicMember member: String) -> Int {
        let properties = ["age": 26, "height": 178]
        return properties[member, default: 0]
    }
}

let taylor = Person()
print(taylor.name as String)
print(taylor.city as String)
print(taylor.favoriteIceCream as String)
let age: Int = taylor.age
print(age)

@dynamicMemberLookup
class PersonClass {
    subscript(dynamicMember member: String) -> String {
        return "Taylor Swift"
    }
}

class User: PersonClass {}
let twostraws = User()
print(twostraws.name)


@dynamicMemberLookup
enum JSON {
    case intValue(Int)
    case stringValue(String)
    case arrayValue(Array<JSON>)
    case dictionaryValue(Dictionary<String, JSON>)
    
    var stringValue: String? {
        if case .stringValue(let str) = self {
            return str
        }
        return nil
    }
    
    subscript(index: Int) -> JSON? {
        if case .arrayValue(let arr) = self {
            return index < arr.count ? arr[index] : nil
        }
        return nil
    }
    
    subscript(key: String) -> JSON? {
        if case .dictionaryValue(let dict) = self {
            return dict[key]
        }
        return nil
    }
    
    subscript(dynamicMember member: String) -> JSON? {
        if case .dictionaryValue(let dict) = self {
            return dict[member]
        }
        return nil
    }
}

let json = JSON.dictionaryValue(["name": .stringValue("33")])
print(json)
print(json.name?.stringValue ?? "xx")
//print(json.name?.stringValue)
//json.name = "peak"
//print(json)


/// https://www.swiftbysundell.com/tips/combining-dynamic-member-lookup-with-key-paths/
///
@dynamicMemberLookup
struct Settings {
    var colorTheme = Color.red
    var itemPageSize = 25
    var keepUserLoggedIn = true
    
    subscript(dynamicMember member: String) -> Any? {
        switch member {
        case "colorTheme":
            return colorTheme
        case "itemPageSize":
            return itemPageSize
        case "keepUserLoggedIn":
            return keepUserLoggedIn
        default:
            return nil
        }
    }
}

@dynamicMemberLookup
class Reference<Value> {
    fileprivate(set) var value: Value
    
    init(value: Value) {
        self.value = value
    }
    
    subscript<T>(dynamicMember keyPath: KeyPath<Value, T>) -> T {
        value[keyPath: keyPath]
    }
}

class MutableReference<Value>: Reference<Value> {
    subscript<T>(dynamicMember keyPath: WritableKeyPath<Value, T>) -> T {
        get { value[keyPath: keyPath] }
        set { value[keyPath: keyPath] = newValue }
    }
}

var reference = MutableReference(value: Settings())
reference.colorTheme = .blue
reference.keepUserLoggedIn = false
print(String(describing: reference))
