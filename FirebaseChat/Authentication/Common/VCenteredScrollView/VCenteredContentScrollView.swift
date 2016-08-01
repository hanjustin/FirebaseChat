
import Foundation
import UIKit

//VerticallyCenteredContentScrollView
class VCenteredContentScrollView: UIScrollView {
    // In IB, container should be a top-level object instead of being a subview of the scrollView
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
}

// MARK: - Private methods

private extension VCenteredContentScrollView {
    func setup() {
        setContainerViewConstraints()
        setContentViewConstraints()
    }
    
    func setContainerViewConstraints() {
        addSubview(containerView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        containerView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        containerView.heightAnchor.constraint(greaterThanOrEqualTo: heightAnchor).isActive = true
    }
    
    func setContentViewConstraints() {
        
        let containerMargins = containerView.layoutMarginsGuide
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.leftAnchor.constraint(equalTo: containerMargins.leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: containerMargins.rightAnchor).isActive = true
        contentView.centerYAnchor.constraint(equalTo: containerMargins.centerYAnchor).isActive = true
        contentView.heightAnchor.constraint(lessThanOrEqualTo: containerMargins.heightAnchor).isActive = true
    }
}
