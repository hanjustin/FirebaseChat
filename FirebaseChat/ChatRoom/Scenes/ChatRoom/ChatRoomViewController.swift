
import UIKit
import JSQMessagesViewController

class ChatRoomViewController: JSQMessagesViewController {
    private let outgoingBubbleImageView = JSQMessagesBubbleImageFactory()?.outgoingMessagesBubbleImage(with: .jsq_messageBubbleGreen())
    private let incomingBubbleImageView = JSQMessagesBubbleImageFactory()?.incomingMessagesBubbleImage(with: .jsq_messageBubbleLightGray())
    private let randomMessages = ["Hello", "Hi", "How are you doing?", "Goodbye"]
    
    private lazy var messagesObserver: DatabaseObserver = DatabaseObserver(rootRef: .chatRoom_Messages, ObjectID: self.chatRoomID)
    private lazy var messagesRef: DatabaseUpdater = DatabaseUpdater(rootRef: .chatRoom_Messages, ObjectID: self.chatRoomID)
    
    var recipient: User!
    var chatRoomID: String!
    
    var messages: [JSQMessage] = [] {
        didSet { finishSendingMessage() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        senderId = AuthManager.sharedInstance.signedInUser?.uniqueID
        collectionView.reloadData()
        setUpChatRoomViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        messagesObserver.observe(event: .childAdded) { (key: String, value: [String : AnyObject]) in
            guard let message = JSQMessage(dict: value) else { return }
            self.messages.append(message)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        messagesObserver.stopAllObservings()
    }
    
    func receiveRandomMessage(sender: UIBarButtonItem) {
        let randomIndex = Int(arc4random_uniform(UInt32(randomMessages.count)))
        let text = randomMessages[randomIndex]
        guard let randomMessage = JSQMessage(
            senderId: recipient.uniqueID,
            displayName: recipient.name,
            text: text)
            else { return }
        sendMessage(randomMessage)
    }
}

// MARK: - JSQMessagesCollectionView

extension ChatRoomViewController {
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.row]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        return isSentMessageFor(indexPath) ? outgoingBubbleImageView : incomingBubbleImageView
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath)
        
        if let messageCell = cell as? JSQMessagesCollectionViewCell {
            messageCell.textView.textColor = isSentMessageFor(indexPath) ? .white() : .black()
        }
        
        return cell
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        guard let newMessage = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text) else { return }
        sendMessage(newMessage)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
}

private extension ChatRoomViewController {
    func setUpChatRoomViews() {
        createMessageReceiveSimulatorButton()
        removeAvatars()
        putTextFieldAboveTabBar()
        disableAttachmentButton()
    }
    
    func createMessageReceiveSimulatorButton() {
        let simulatorButton = UIBarButtonItem(title: "Simulate Receiving", style: .plain, target: self, action: #selector(receiveRandomMessage))
        navigationItem.rightBarButtonItem = simulatorButton
    }

    func removeAvatars() {
        collectionView.collectionViewLayout.incomingAvatarViewSize = .zero;
        collectionView.collectionViewLayout.outgoingAvatarViewSize = .zero;
    }
    
    func putTextFieldAboveTabBar() {
        edgesForExtendedLayout = UIRectEdge()
    }
    
    func disableAttachmentButton() {
        inputToolbar.contentView.leftBarButtonItem = nil
    }
    
    func isSentMessageFor(_ indexPath: NSIndexPath) -> Bool {
        let message = messages[indexPath.row]
        return message.senderId == senderId
    }
    
    func sendMessage(_ message: JSQMessage) {
        let sendNewMessage = messagesRef.childByAutoID()
        _ = sendNewMessage.stageUpdate(value: message.toDictionary())
        DatabaseUpdater.commitUpdates(of: sendNewMessage)
    }
}

