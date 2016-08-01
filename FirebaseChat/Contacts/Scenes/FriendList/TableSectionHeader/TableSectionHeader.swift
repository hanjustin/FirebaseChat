
import UIKit

protocol TableSectionHeaderDelegate: class {
    func didTapHeaderForSection(_ section: Int)
}

class TableSectionHeader: UITableViewHeaderFooterView {
    @IBOutlet weak var signLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    weak var delegate: TableSectionHeaderDelegate?
    var section = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        addGestureRecognizer(tap)
    }
    
    func tapped(tap: UIGestureRecognizer) {
        delegate?.didTapHeaderForSection(section)
    }
}

