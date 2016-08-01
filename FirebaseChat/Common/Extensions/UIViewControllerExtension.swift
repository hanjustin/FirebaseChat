
import Foundation
import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditingView))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func endEditingView() {
        view.endEditing(true)
    }
    
    func presentOKAlertWith(title: String?, message: String?, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: handler)
        
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
}
