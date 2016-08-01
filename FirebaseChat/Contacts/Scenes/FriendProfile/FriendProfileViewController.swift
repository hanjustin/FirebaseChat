
import UIKit

class FriendProfileViewController: UIViewController {
    @IBOutlet private weak var userView: UserView!
    
    var friend: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userView.user = friend
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let identifier = segue.identifier else { return }
        
        switch (identifier, segue.destinationViewController) {
        case ("ShowChatRoomVC", let destinationVC as ChatRoomViewController):
            destinationVC.senderDisplayName = ""
            destinationVC.chatRoomID = sender as? String
            destinationVC.recipient = friend
        default:
            break
        }
    }
}

private extension FriendProfileViewController {
    @IBAction func tappedChatButton(_ sender: UIButton) {
        getChatRoomID { chatRoomID, error in
            guard error == nil else { return self.presentOKAlertWith(title: "Error", message: error?.localizedDescription) }
            self.performSegue(withIdentifier: "ShowChatRoomVC", sender: chatRoomID)
        }
    }
    
    func getChatRoomID(completion: (chatRoomID: String, error: NSError?) -> Void) {
        findExistingChatRoomID { chatRoomID in
            guard let chatRoomID = chatRoomID else { return self.getNewChatRoomID(completion: completion) }
            completion(chatRoomID: chatRoomID, error: nil)
        }
    }
    
    func findExistingChatRoomID(completion: (chatRoomID: String?) -> Void) {
        DatabaseObserver(rootRef: .user_ChatRooms, ObjectID: signedInUserID)
            .setQueryValue(relatedBy: .equal, value: friend.uniqueID)
            .observeOnceFor(event: .value) { (_, dict: [String : AnyObject]?) in
                completion(chatRoomID: dict?.keys.first)
        }
    }

    func getNewChatRoomID(completion: (chatRoomID: String, error: NSError?) -> Void) {
        let newChatRoom = createNewChatRoom()
        let newRoomID = newChatRoom.key
        DatabaseUpdater.commitUpdates(of: newChatRoom, linkChatRoomToUsers(chatRoomID: newRoomID)) { error in
            completion(chatRoomID: newRoomID, error: error)
        }
    }
    
    func createNewChatRoom() -> DatabaseUpdater {
        return DatabaseUpdater(rootRef: .chatRooms).childByAutoID().stageUpdate(value: true)
    }
    
    func linkChatRoomToUsers(chatRoomID: String) -> DatabaseUpdater {
        /*  Updates database to:
            user_ChatRooms {
                signedInUserID {
                    chatRoomID : friendID
                }
                friendID {
                    chatRoomID : signedInUserID
                }
            }
         */
        let linker = DatabaseUpdater(rootRef: .user_ChatRooms)
        _ = linker.stageChildUpdate(pathComponents: signedInUserID, chatRoomID, value: friend.uniqueID)
        _ = linker.stageChildUpdate(pathComponents: friend.uniqueID, chatRoomID, value: signedInUserID)
        return linker
    }
    
    var signedInUserID: String! {
        return AuthManager.sharedInstance.signedInUser?.uniqueID
    }
}
