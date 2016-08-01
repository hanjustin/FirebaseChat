
import Foundation
import JSQMessagesViewController

extension JSQMessage  {
    convenience init!(dict: [String : AnyObject]) {
        self.init(
            senderId: dict[(#keyPath(JSQMessage.senderId))] as? String,
            displayName: dict[(#keyPath(JSQMessage.senderDisplayName))] as? String,
            text: dict[(#keyPath(JSQMessage.text))] as? String
        )
    }
    
    func toDictionary() -> [String : AnyObject] {
        var dict: [String : AnyObject] = [:]
        dict[(#keyPath(JSQMessage.senderId))] = senderId
        dict[(#keyPath(JSQMessage.senderDisplayName))] = senderDisplayName
        dict[(#keyPath(JSQMessage.text))] = text
        return dict
    }
}
