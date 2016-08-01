
import UIKit

class UserView: ViewFromXib {
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    
    var user: User! {
        didSet {
            emailLabel.text = user.email
            nameLabel.text = user.name
        }
    }
}
