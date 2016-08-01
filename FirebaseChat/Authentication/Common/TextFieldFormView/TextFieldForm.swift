
import Foundation
import UIKit

@IBDesignable
class TextFieldForm: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    @IBInspectable var title: String? {
        get { return titleLabel.text }
        set { titleLabel.text = newValue }
    }
    
    @IBInspectable var inputText: String? {
        get { return textField.text }
        set { textField.text = newValue }
    }
    
    @IBInspectable var placeHolder: String? {
        get { return textField.placeholder }
        set { textField.placeholder = newValue }
    }
    
    @IBInspectable var errorMessage: String? {
        get { return errorMessageLabel.text }
        set { errorMessageLabel.text = newValue }
    }
    
    @IBInspectable var hideErrorMessageLabel = false {
        didSet { errorMessageLabel.isHidden = hideErrorMessageLabel }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromXIB()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromXIB()
    }
}

// MARK: - Private methods

private extension TextFieldForm {
    func loadViewFromXIB() {
        guard let loadedView = UINib(nibName: String(self.dynamicType), bundle: Bundle(for: self.dynamicType)).instantiate(withOwner: self, options: nil).first as? UIView else { fatalError("Failed loading nib file") }
        
        insertSubview(loadedView, at: 0)
        loadedView.frame = self.bounds
        loadedView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}
