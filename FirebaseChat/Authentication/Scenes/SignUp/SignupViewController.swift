
import Foundation
import UIKit

class SignupViewController: SignInViewController {
    private let simulateFriendRequestSender = "8vkOpCJFEeOW0uGqvrPARp7jcIM2"
    
    // Attempted error handling with do-try-catch. Not sure if this is the best way
    private enum Error: ErrorProtocol {
        enum Title {
            static let FailedFormValidation = "Invalid input"
            static let FailedAccountCreation = "Failed Creating Account"
        }
        
        enum Msg {
            static let NotMatchingPasswords = "Entered passwords do not match. Please try again."
            static let InvalidEmailPassword = "Please enter valid email & password"
            static let InvalidName = "Please enter a valid name"
            static let FailedFetchingUserData = "Failed downloading new user data"
        }
        
        case NotMatchingPasswords
        case InvalidEmailPassword
        case InvalidName
        case FailedFetchingUserData
        
        var title: String {
            switch self {
            case .NotMatchingPasswords, .InvalidName, .InvalidEmailPassword: return Title.FailedFormValidation
            case .FailedFetchingUserData: return Title.FailedAccountCreation
            }
        }
        
        var message: String {
            switch self {
            case .NotMatchingPasswords: return Msg.NotMatchingPasswords
            case .InvalidEmailPassword: return Msg.InvalidEmailPassword
            case .InvalidName: return Msg.InvalidName
            case .FailedFetchingUserData: return Msg.FailedFetchingUserData
            }
        }
    }
    
    @IBOutlet private weak var confirmPasswordFormSection: TextFieldForm! {
        didSet { confirmPasswordFormSection.textField.isSecureTextEntry = true }
    }
    @IBOutlet private weak var nameFormSection: TextFieldForm!
}

private extension SignupViewController {
    @IBAction func tappedCreateUserButton(_ sender: UIButton) {
        do {
            let (email, password, name) = try getFormData()

            sender.isEnabled = false
            
            createUserWith(email: email, password: password, name: name) { newUser, error in
                sender.isEnabled = true
                
                guard let _ = newUser where error == nil else {
                    self.presentOKAlertWith(
                        title: Error.Title.FailedAccountCreation,
                        message: error?.localizedDescription ?? Error.Msg.FailedFetchingUserData)
                    return
                }
                
                self.performSegue(withIdentifier: "GotoContactsStoryboard", sender: nil)
            }
            
        } catch let error {
            guard let error = error as? Error else { return }
            presentOKAlertWith(title: error.title, message: error.message)
        }
    }
    
    func getFormData() throws -> (email: String, password: String, name: String) {
        guard let (email, password) = getValidEmailAndPassword() else { throw Error.InvalidEmailPassword }
        guard let confirmedPassword = confirmPasswordFormSection.inputText where password == confirmedPassword else {
            throw Error.NotMatchingPasswords
        }
        guard let name = nameFormSection.inputText where name.isEmpty.isFalse else { throw Error.InvalidName }
        return (email: email, password: password, name: name)
    }
    
    func createUserWith(email: String, password: String, name: String, completionHandler: (User?, NSError?) -> Void) {
        AuthManager.sharedInstance.createUserAndSignInWith(email: email, password: password) { userID, error in
            guard let userID = userID where error == nil else { return completionHandler(nil, error) }
            
            let newUser = User(uniqueID: userID)
            newUser.email = email
            newUser.name = name
            
            
            DatabaseUpdater.commitUpdates(of: self.updateNewUserInfo(for: newUser), self.simulateReceivedFriendRequest(for: newUser)) { error in
                completionHandler(newUser, error)
            }
        }
    }
    
    func updateNewUserInfo(for user: User) -> DatabaseUpdater {
        return DatabaseUpdater(rootRef: .users, ObjectID: user.uniqueID)
                .stageUpdate(value: user.toDictionary())
    }
    
    func simulateReceivedFriendRequest(for user: User) -> DatabaseUpdater {
        return DatabaseUpdater(rootRef: .user_FriendRequests, ObjectID: user.uniqueID)
            .stageChildUpdate(pathComponents: simulateFriendRequestSender, value: true)
    }
}
