
import Foundation
import Firebase

class AuthManager {
    static let sharedInstance = AuthManager()
    
    var hasSignedInUser: Bool { return signedInUser != nil }
    private(set) lazy var signedInUser: AuthenticatedUser? = FIRAuth.auth()?.currentUser
    
    private init() {
        FIRApp.configure()
        FIRDatabase.database().persistenceEnabled = true
        FIRAuth.auth()?.addStateDidChangeListener { [weak self] auth, user in
            // Updates signedInUser when user signs in or signs out
            self?.signedInUser = user
        }
    }
}

extension AuthManager {
    func createUserAndSignInWith(
        email: String,
        password: String,
        completion: (userID: String?, error: NSError?) -> Void)
    {
        FIRAuth.auth()?.createUser(withEmail: email, password: password) { (FIRUser, error) in
            completion(userID: FIRUser?.uid, error: error)
        }
    }
    
    func signInWith(
        email: String,
        password: String,
        completion: (userID: String?, error: NSError?) -> Void)
    {
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (FIRUser, error) in
            completion(userID: FIRUser?.uid, error: error)
        }
    }
    
    func signOut() throws {
        try FIRAuth.auth()?.signOut()
    }
}
