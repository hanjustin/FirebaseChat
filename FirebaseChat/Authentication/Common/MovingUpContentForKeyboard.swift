
import Foundation
import UIKit

protocol MovingUpContentForKeyboard {
    associatedtype contentViewType: UIView
    
    var contentView: contentViewType { get }
}

extension MovingUpContentForKeyboard where Self: UIViewController, contentViewType: UIScrollView {
    func observeKeyboardTransitionNotifications() {
        NotificationCenter.default().addObserver(forName: .UIKeyboardWillShow, object: nil, queue: .main(), using: scrollUpContent)
        NotificationCenter.default().addObserver(forName: .UIKeyboardWillHide, object: nil, queue: .main(), using: scrollUpContent)
    }
    
    func scrollUpContent(notification: Notification) {
        guard
            let userInfo = (notification as NSNotification).userInfo,
            let keyboardHeight = userInfo[UIKeyboardFrameEndUserInfoKey]?.cgRectValue.height
            else { return }
        
        let moveUp = (notification.name == .UIKeyboardWillShow)
        
        let edgeInsets = moveUp ? UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0) : UIEdgeInsetsZero
        
        contentView.contentInset = edgeInsets
        contentView.scrollIndicatorInsets = edgeInsets
    }
}
