import UIKit
import Foundation

@propertyWrapper
struct SecureStorage<Value> {
    let key: String
    let defaultValue: Value
    
    var wrappedValue: Value {
        get {
            print("get object for \(key)")
            return (UserDefaults.standard.object(forKey: key) as? Value) ?? defaultValue
        }
        set {
            print("set \(key) with \(newValue)")
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
    
    var projectedValue: Value {
        print("get projectValue")
        return defaultValue
    }
}


struct Person {
    @SecureStorage(key: "Name", defaultValue: "peak")
    var name: String
    
    init() {
        print("-- init: " + self.name)
        print("-- init: " + self.$name)
    }
    
    mutating func changeName(newName: String) {
        name = newName
        
        print("-- change: " + self.$name)
    }
}

var p = Person()
print(p.name)
p.changeName(newName: "peak plus")
print(p.name)

