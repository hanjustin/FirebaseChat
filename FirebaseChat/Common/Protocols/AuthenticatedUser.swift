
import Foundation

protocol AuthenticatedUser {
    var uniqueID: String { get }
    var displayName: String? { get }
    var email: String? { get }
    
    // TO DO: - functions to update profile
}
