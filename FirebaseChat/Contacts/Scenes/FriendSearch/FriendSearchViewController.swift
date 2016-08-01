
import UIKit

class FriendSearchViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.hideBottomEmptyCellsWithBlankFooter()
        }
    }
    @IBOutlet private weak var searchTextField: UITextField! {
        didSet {
            searchTextField.text = "testuser@gmail.com"
        }
    }
    
    private var foundUsers: [User] = []
    private var didPerformSearch = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let identifier = segue.identifier else { return }
        
        switch (identifier, segue.destinationViewController) {
        case ("ShowFriendRequestVC", let destination as FriendRequestViewController):
            guard let selectedRow = tableView.indexPathForSelectedRow?.row else { return }
            destination.isSendingFriendRequest = true
            destination.user = foundUsers[selectedRow]
        default: break
        }
    }
}

private extension FriendSearchViewController {
    @IBAction func searchUserButtonTapped(_ sender: UIButton) {
        guard let searchText = searchTextField.text where searchText.isEmpty.isFalse else { return }
        
        didPerformSearch = true
        sender.isEnabled = false
        
        DatabaseObserver(rootRef: .users)
            .setQuery(keypath: #keyPath(User.email), relatedBy: .equal, value: searchText)
            .observeOnceFor(event: .value) { (_, idPropertyDictPair: [String : AnyObject]?) in
                var foundUsers = [User]()
                
                defer {
                    sender.isEnabled = true
                    self.foundUsers = foundUsers
                    self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
                }
                
                guard let idPropertyDictPair = idPropertyDictPair else { return }
                for (id, propertyDict) in idPropertyDictPair {
                    let mappedUser = User(uniqueID: id, propertyDict: propertyDict as? [String : AnyObject])
                    foundUsers.append(mappedUser)
                }
        }
    }
}

extension FriendSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return didPerformSearch ? max(foundUsers.count, 1) : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard hasValidSearchResult() else { return noResultCell() }

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let user = foundUsers[indexPath.row]
        cell.textLabel?.text = user.email
        return cell
    }
    
    func hasValidSearchResult() -> Bool {
        return foundUsers.count > 0
    }
    
    func noResultCell() -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = "User not found"
        return cell
    }
}

extension FriendSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer { tableView.deselectRow(at: indexPath, animated: false) }
        
        guard hasValidSearchResult() else { return }
        performSegue(withIdentifier: "ShowFriendRequestVC", sender: nil)
    }
}
