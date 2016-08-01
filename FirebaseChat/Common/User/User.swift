
import Foundation

class User: NSObject, DatabaseObject {
    class var RootRefKey: String { return DatabaseReference.RootRefKey.users.rawValue }
    
    let uniqueID: String
    
    var email = ""
    var name = ""
    
    required init(uniqueID: String, propertyDict: [String : AnyObject]? = nil) {
        self.uniqueID = uniqueID
        
        super.init()

        self.email <- propertyDict?[(#keyPath(User.email))]
        self.name <- propertyDict?[(#keyPath(User.name))]
    }
}
