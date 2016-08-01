
import Foundation

extension Optional where Wrapped: PossiblyEmpty {
    var nonEmptyValue: Optional {
        switch self {
        case .none: return self
        case .some(let someValue): return someValue.nonEmptyValue
        }
    }
}
