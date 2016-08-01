
import Foundation
import UIKit

class SignInViewController: UIViewController {
    private enum Error {
        enum Title {
            static let FailedSignIn = "Failed Signing In"
        }
        
        enum Msg {
            static let InvalidEmailPassword = "Please enter valid email & password"
            static let FailedFetchingUserData = "Failed downloading new user data"
        }
    }
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var emailFormSection: TextFieldForm!
    @IBOutlet private weak var passwordFormSection: TextFieldForm! {
        didSet { passwordFormSection.textField.isSecureTextEntry = true }
    }
}

extension SignInViewController {
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        observeKeyboardTransitionNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default().removeObserver(self)
    }
    
    func getValidEmailAndPassword() -> (email: String, password: String)? {
        guard
            let email = emailFormSection.inputText,
            let password = passwordFormSection.inputText
            where email.isEmpty.isFalse && password.isEmpty.isFalse
            else { return nil }
        
        return (email, password)
    }
}

private extension SignInViewController {
    @IBAction func tappedSignInButton(_ sender: UIButton) {
        guard let (email, password) = getValidEmailAndPassword() else {
            return presentOKAlertWith(title: "Error", message: Error.Msg.InvalidEmailPassword)
        }
        
        sender.isEnabled = false
        
        signInWith(email: email, password: password) { signedInUser, error in
            sender.isEnabled = true
            
            guard let _ = signedInUser where error == nil else {
                self.presentOKAlertWith(
                    title: Error.Title.FailedSignIn,
                    message: error?.localizedDescription ?? Error.Msg.FailedFetchingUserData)
                return
            }
            
            self.performSegue(withIdentifier: "GotoContactsStoryboard", sender: nil)
        }
    }
    
    func signInWith(email: String, password: String, completionHandler: (User?, NSError?) -> Void) {
        AuthManager.sharedInstance.signInWith(email: email, password: password) { userID, error in
            guard let userID = userID where error == nil else { return completionHandler(nil, error) }
            
            DatabaseObserver.fetchObject(type: User.self, id: userID) { user in
                completionHandler(user, error)
            }
        }
    }
}

// MARK: - MovingUpContentForKeyboard

extension SignInViewController: MovingUpContentForKeyboard {
    var contentView: UIScrollView { return scrollView }
}
