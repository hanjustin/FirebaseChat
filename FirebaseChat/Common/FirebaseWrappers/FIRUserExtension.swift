
import Foundation
import FirebaseAuth

extension FIRUser: AuthenticatedUser {
    var uniqueID: String { return uid }
}
