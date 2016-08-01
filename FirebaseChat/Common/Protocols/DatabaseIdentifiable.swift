
import Foundation

protocol DatabaseIdentifiable {
    static var RootRefKey: String { get }
    
    var uniqueID: String { get }
    
    func toDictionary() -> [String : AnyObject]
}
