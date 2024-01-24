//
//  SMClonable.swift
//  
//
//  Created by Andre Pham on 17/7/2023.
//

import Foundation

public protocol SMClonable {

    init(_ original: Self)
    
}
extension SMClonable {
    
    public func clone() -> Self {
        return type(of: self).init(self)
    }
    
}
extension Array where Element: SMClonable {
    
    public func clone() -> Array {
        var clonedArray = Array<Element>()
        for element in self {
            clonedArray.append(element.clone())
        }
        return clonedArray
    }
    
}
extension Dictionary where Value: SMClonable {
    
    public func clone() -> Dictionary {
        var clonedDictionary = Dictionary<Key, Value>()
        for pair in self {
            clonedDictionary[pair.key] = pair.value.clone()
        }
        return clonedDictionary
    }
    
}
