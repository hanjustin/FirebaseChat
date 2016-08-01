
import UIKit

/* Current Business logic:
 * A sending friend request to B: Add B to A's contact list. Add friend request from A to B's request list.
 * A declining friend request from B: Delete A from B's contact list. Delete the friend request.
 */

class FriendRequestViewController: UIViewController {
    @IBOutlet private weak var userView: UserView!
    @IBOutlet private weak var sendRequestButton: UIButton! {
        didSet {
            sendRequestButton.isHidden = isSendingFriendRequest.isFalse
        }
    }
    @IBOutlet private weak var acceptRequestButton: UIButton! {
        didSet {
            acceptRequestButton.isHidden = isSendingFriendRequest
        }
    }
    @IBOutlet private weak var declineRequestButton: UIButton! {
        didSet {
            declineRequestButton.isHidden = isSendingFriendRequest
        }
    }
    
    var user: User!
    var isSendingFriendRequest = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userView.user = user
    }
}

private extension FriendRequestViewController {
    enum UserAction {
        case sendRequest, acceptRequest, declineRequest
    }
    
    @IBAction func tappedSendFriendRequest(_ sender: UIButton) {
        handleUser(action: .sendRequest, from: sender)
    }
    
    @IBAction func tappedAcceptFriendRequest(_ sender: UIButton) {
        handleUser(action: .acceptRequest, from: sender)
    }
    
    @IBAction func tappedDeclineFriendRequest(_ sender: UIButton) {
        handleUser(action: .declineRequest, from: sender)
    }

    func handleUser(action: UserAction, from sender: UIButton) {
        let handler: ((NSError?) -> Void) -> Void
        switch action {
        case .sendRequest: handler = sendFriendRequest
        case .acceptRequest: handler = acceptFriendRequest
        case .declineRequest: handler = declineFriendRequest
        }
        
        sender.isEnabled = false
        handler { error in
            sender.isEnabled = true
            if let error = error {
                self.presentOKAlertWith(title: "Error", message: error.localizedDescription)
            } else {
                for case let vc as FriendListViewController in (self.navigationController?.viewControllers ?? []) {
                    _ = self.navigationController?.popToViewController(vc, animated: true)
                    break
                }
            }
        }
    }
    
    func sendFriendRequest(completionHandler: (NSError?) -> Void) {
        DatabaseUpdater.commitUpdates(of: addUserToContacts(), sendFriendRequest(), completionHandler: completionHandler)
    }
    
    func acceptFriendRequest(completionHandler: (NSError?) -> Void) {
        DatabaseUpdater.commitUpdates(of: addUserToContacts(), deleteReceivedRequest(), completionHandler: completionHandler)
    }
    
    func declineFriendRequest(completionHandler: (NSError?) -> Void) {
        DatabaseUpdater.commitUpdates(of: deleteCurrentUserInContactOfSender(), deleteReceivedRequest(), completionHandler: completionHandler)
    }
    
    func sendFriendRequest() -> DatabaseUpdater {
        let receiverID = user.uniqueID
        return DatabaseUpdater(rootRef: .user_FriendRequests, ObjectID: receiverID)
            .appendedChildPath(signedInUserID)
            .stageUpdate(value: true)
    }
    
    func addUserToContacts() -> DatabaseUpdater {
        let newFriendID = user.uniqueID
        return DatabaseUpdater(rootRef: .user_Friends, ObjectID: signedInUserID)
            .appendedChildPath(newFriendID)
            .stageUpdate(value: true)
    }
    
    func deleteReceivedRequest() -> DatabaseUpdater {
        let senderID = user.uniqueID
        return DatabaseUpdater(rootRef: .user_FriendRequests, ObjectID: signedInUserID)
            .appendedChildPath(senderID)
            .stageUpdate(value: nil)
    }
    
    func deleteCurrentUserInContactOfSender() -> DatabaseUpdater {
        let senderID = user.uniqueID
        return DatabaseUpdater(rootRef: .user_Friends, ObjectID: senderID)
            .appendedChildPath(signedInUserID)
            .stageUpdate(value: nil)
    }
    
    var signedInUserID: String! {
        return AuthManager.sharedInstance.signedInUser?.uniqueID
    }
}
