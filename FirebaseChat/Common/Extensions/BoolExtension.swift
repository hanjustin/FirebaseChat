
import Foundation

extension Bool {
    mutating func toggle() {
        self = !self
    }
    
    var isFalse: Bool {
        return self == false
    }
}
