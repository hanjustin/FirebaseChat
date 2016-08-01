
import UIKit

class ViewFromXib: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromXIB()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromXIB()
    }
}

private extension ViewFromXib {
    func loadViewFromXIB() {
        guard let loadedView = UINib(nibName: String(self.dynamicType), bundle: Bundle(for: self.dynamicType)).instantiate(withOwner: self, options: nil).first as? UIView else { fatalError("Failed loading nib file") }
        
        insertSubview(loadedView, at: 0)
        loadedView.frame = self.bounds
        loadedView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}

