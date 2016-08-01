
import Foundation

extension String: PossiblyEmpty {
    var nonEmptyValue: String? {
        return self == "" ? nil : self
    }
}
