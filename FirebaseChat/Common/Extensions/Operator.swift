
import Foundation

infix operator <- {}

func <- <T>(lhs: inout T, rhs: AnyObject?) {
    if let validTypeData = rhs as? T { lhs = validTypeData }
}
