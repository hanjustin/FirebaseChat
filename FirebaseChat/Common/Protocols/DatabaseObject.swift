
import Foundation

protocol DatabaseObject: DatabaseIdentifiable {
    init(uniqueID: String, propertyDict: [String : AnyObject]?)
}

extension DatabaseObject {
    func toDictionary() -> [String : AnyObject] {
        var mirror: Mirror? = Mirror(reflecting: self)
        var objectDictionary = [String : AnyObject]()
        
        while let currentMirror = mirror {
            for (propertyName, value) in currentMirror.children {
                if let propertyName = propertyName { objectDictionary[propertyName] = value as? AnyObject }
            }
            
            mirror = currentMirror.superclassMirror
        }
        objectDictionary["uniqueID"] = nil

        return objectDictionary
    }
}
